//
//  MainVC+AddBooks.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/7/9.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

/*
 Action Sheet
 */

extension MainVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate {
    @IBAction func addBtnTapped(_ sender: Any) {

        addSlideUpManager.toggleSlideUpView(in: self.view)

        // showAttachmentActionSheet(sender as! UIButton)
    }

//    func showAttachmentActionSheet(_ sender: UIButton) {
//        let actionSheet = UIAlertController(title: "add a picture...", message: "", preferredStyle: .actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in self.fromCamera() }))
//
//        actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { _ in self.fromPhotos() }))
//
//        actionSheet.addAction(UIAlertAction(title: "Files", style: .default, handler: { _ in self.fromFiles() }))
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
//
//
//        actionSheet.popoverPresentationController?.sourceView = sender
//        actionSheet.popoverPresentationController?.sourceRect = sender.bounds
//        actionSheet.popoverPresentationController?.permittedArrowDirections = .up
//
//        self.present(actionSheet, animated: true, completion: nil)
//    }


    @IBAction func camBtnTapped(_ sender: Any) {
        fromCamera()
    }

    @IBAction func photoBtnTapped(_ sender: Any) {
        fromPhotos()
    }

    @IBAction func fileBtnTapped(_ sender: Any) {
        fromFiles()
    }


    func fromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = false
            present(myPickerController, animated: true, completion: nil)
        }
    }



    func fromPhotos(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            present(myPickerController, animated: true, completion: nil)
        }
    }


    func fromFiles(){
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        present(importMenu, animated: true, completion: nil)
    }



    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Success")
        if let pickImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            booksManager.insertBook(refImg: pickImg, tasksList: []) { (completed) in
                booksManager.fetchAllBooks(completion: { (_) in })
                booksCollection.reloadData()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }


}
