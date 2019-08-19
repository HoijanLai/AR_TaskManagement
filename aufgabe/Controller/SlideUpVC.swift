//
//  SlideUpVC.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/8/12.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

protocol SlideUpVCDelegate: class {
    func onSlideUpViewShow()
    func onSlideUpViewDismiss()
}

class SlideUpVC: UIViewController {

    weak var delegate: SlideUpVCDelegate?




    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let addView = AddItemView(frame: self.view.bounds)
        addView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addView.delegate = self
        self.view.addSubview(addView)
        delegate?.onSlideUpViewShow()



        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onUserSlideDown(_:)))

    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        slideDown()
        super.dismiss(animated: false, completion: nil)
    }


    private func slideDown() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: 0,
                                     y: self.view.frame.minY + self.view.frame.height,
                                     width: self.view.frame.width,
                                     height: self.view.frame.height)
            self.delegate?.onSlideUpViewDismiss()
        }) { (_) in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }

    @objc
    func onUserSlideDown(_ gesture: UIPanGestureRecognizer) {
        
    }


}



extension SlideUpVC: AddItemViewDelegate,
                     UIImagePickerControllerDelegate,
                     UIDocumentPickerDelegate,
                     UINavigationControllerDelegate
{
    
    func showItemsBtnTapped() {
        let showView = ShowItemsView(frame: self.view.bounds)
        showView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        showView.delegate = self

        self.view.addSubview(showView)
        showView.presentUI()
    }

    func fromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = false
            // present(myPickerController, animated: true, completion: nil)
        }
    }

    func fromPhotos(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            // present(myPickerController, animated: true, completion: nil)
        }
    }


    func fromFiles(){
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        // present(importMenu, animated: true, completion: nil)
    }



    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Success")
        if let pickImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            booksManager.insertBook(refImg: pickImg, tasksList: []) { (completed) in
                booksManager.fetchAllBooks(completion: { (_) in })
                // booksCollection.reloadData()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    // for both AddItemView and ShowItemView
    func helpDismiss() {
        dismiss(animated: false, completion: nil)
    }



}

extension SlideUpVC: showItemsViewDelegate {
    func backBtnTapped() {
        let addView = AddItemView(frame: self.view.bounds)
        addView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addView.delegate = self

        self.view.addSubview(addView)
        addView.presentUI()
    }

}




