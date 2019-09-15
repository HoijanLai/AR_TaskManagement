//
//  ItemDetailVC.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/9/12.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit


class ItemDetailVC: UIViewController {


    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemTextView: UIView!
    @IBOutlet weak var itemInputView: UIView!
    @IBOutlet weak var itemInputField: UITextField!
    @IBOutlet weak var itemCoverImg: UIImageView!


    var item: Book!
    var iP: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let itemImg = UIImage(data: item.refImage!) else { return }

        itemCoverImg.image = itemImg

        itemTitleLabel.text = item.name
        itemTextView.isHidden = false


        itemInputField.text = item.name
        itemInputView.isHidden = true
        itemInputField.delegate = self

        
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 1
        }) 
    }


    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        view.alpha = 1
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        })


        super.dismiss(animated: flag, completion: completion)
    }




    func configWithItemId(itemId: UUID, at indexPath: IndexPath) {


        // TODO: Hint
        guard let currentItem = itemsManager.getItemForId(itemId) else { return }
        self.item = currentItem
        self.iP = indexPath
        // TODO: Hint


    }






    @IBAction func confirmBtnTapped(_ sender: UIButton) {
        onConfirm()
    }


    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        onCancel()
    }


    @IBAction func imageEditBtnTapped(_ sender: UIButton) {
        onEditImage()
    }


    @IBAction func textEditBtnTapped(_ sender: UIButton) {
        onEditText()
    }



}





extension ItemDetailVC: UITextFieldDelegate {

    private func onConfirm() {
        itemsManager.editNameForItem(item: self.item, name: self.itemTitleLabel.text!)
        itemsManager.editCoverForItem(item: self.item, image: self.itemCoverImg.image!, self.iP)
        dismiss(animated: true) {
            if let mainScreen = UIApplication.shared.keyWindow?.rootViewController as? MainVC {
                print("success")
                mainScreen.presentSlideUp(state: .viewItem)
            }
        }


    }

    private func onCancel() {
        dismiss(animated: false) {
            if let mainScreen = UIApplication.shared.keyWindow?.rootViewController as? MainVC {
                mainScreen.presentSlideUp(state: .viewItem)
            }
        }

    }

    private func onEditImage() {
        presentPickerControl()
    }

    private func onEditText() {
        itemTextView.isHidden = true
        itemInputView.isHidden = false

    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        itemTitleLabel.text = textField.text
        itemTextView.isHidden = false

        itemInputField.text = textField.text
        itemInputView.isHidden = true



    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // User finished typing (hit return): hide the keyboard.
        textField.resignFirstResponder()
        return true
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }


}










extension ItemDetailVC:  UIImagePickerControllerDelegate,
                         UIDocumentPickerDelegate,
                         UINavigationControllerDelegate
    {

    private func presentPickerControl() {
        let options = UIAlertController(title: nil, message: "Edit Image From", preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: self.fromCamera(_:))
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: self.fromPhotos(_:))
        let fileAction = UIAlertAction(title: "Files", style: .default, handler: self.fromFiles(_:))

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        options.addAction(cameraAction)
        options.addAction(photoAction)
        options.addAction(fileAction)
        options.addAction(cancelAction)
        self.present(options, animated: false, completion: nil)
    }


    private func fromCamera(_ sender: UIAlertAction){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.allowsEditing = false

            picker.modalPresentationStyle = .popover
            picker.modalTransitionStyle = .flipHorizontal
            present(picker, animated: true, completion: nil)
        }
    }

    private func fromPhotos(_ sender: UIAlertAction){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            picker.modalPresentationStyle = .popover
            picker.modalTransitionStyle = .flipHorizontal
            present(picker, animated: true, completion: nil)
        }
    }


    private func fromFiles(_ sender: UIAlertAction){
        let picker = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
        picker.delegate = self
        picker.modalPresentationStyle = .formSheet
        picker.modalPresentationStyle = .popover
        picker.modalTransitionStyle = .flipHorizontal
        present(picker, animated: true, completion: nil)
    }



    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickImg = info[.originalImage] as? UIImage {
            itemCoverImg.image = pickImg
        }
        picker.dismiss(animated: true)


    }


}




