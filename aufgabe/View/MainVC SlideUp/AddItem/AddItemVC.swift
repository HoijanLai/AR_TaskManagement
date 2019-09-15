//
//  addItemView.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/8/12.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit




class AddItemVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1
        }
    }

    /*
     transition to view all items view, managed by delegating SlideUpVC
    */
    @IBAction func showItemsBtnTapped(_ sender: Any) {
        showItems()
    }


    @IBAction func camBtnTapped(_ sender: Any) {
        self.fromCamera()
    }

    @IBAction func photoBtnTapped(_ sender: Any) {
        self.fromPhotos()
    }

    @IBAction func fileBtnTapped(_ sender: Any) {
        self.fromFiles()
    }

}









/*
 Add Item Functionalities
 */
extension AddItemVC: UIImagePickerControllerDelegate,
                     UIDocumentPickerDelegate,
                     UINavigationControllerDelegate
{
    private func fromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.allowsEditing = false
            presentPicker(picker)
        }
    }

    private func fromPhotos(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            presentPicker(picker)
        }
    }


    private func fromFiles(){
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        presentPicker(importMenu)
    }


    private func presentPicker(_ picker: UIViewController) {
        guard let nav = navigationController else { return }
        nav.present(picker, animated: true)


    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickImg = info[.originalImage] as? UIImage {
            print("trying")
            itemsManager.insertItem(refImg: pickImg, tasksList: [])
            print("success")
        }
        picker.dismiss(animated: true) {
            self.showItems()
        }

    }




}



extension AddItemVC {

    private func showItems() {
        guard let nav = navigationController else { return }

        UIView.animate(withDuration: 0.1, animations: {
            nav.viewControllers.last?.view.alpha = 0
        }) { (_) in
            nav.popViewController(animated: false)
            nav.pushViewController(ShowItemsVC(nibName: "ShowItemsView", bundle: nil), animated: false)
        }
    }

}


