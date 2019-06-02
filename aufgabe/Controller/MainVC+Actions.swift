//
//  MainVC+Actions.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/4/20.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension MainVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate {


    @objc
    func didTap(_ gesture: UITapGestureRecognizer) {
        let tappedLocation = gesture.location(in: sceneView)

        let hitResults = sceneView.hitTest(tappedLocation, options: [.boundingBoxOnly: true])

        guard let hitNode = hitResults.first?.node else { return }
        guard let hitName = hitNode.name else { return }
        if hitName != "button" { return }
        hitNode.runAction(highlightAction)
        lastHitAnchor = (sceneView.anchor(for: hitNode) as! ARImageAnchor)

        // get the text node binding from a plane (hit test result)

        let TasksVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TasksVC") as! TasksVC
        TasksVC.delegate = self
        TasksVC.modalPresentationStyle = .overFullScreen
        TasksVC.modalTransitionStyle = .crossDissolve
        guard let book = booksManager.getBookForImageAnchor(lastHitAnchor!) else { return }
        TasksVC.initData(booksManager: booksManager, book: book)
        self.present(TasksVC, animated: true)


    }

}

/*
 Interaction with TasksVC
 */
extension MainVC: TaskVCDelegate {
    func onUpdateData() {
        sceneView.session.run(booksManager.getTrackingConfig(), options: .resetTracking)
        if lastHitAnchor != nil {
            updateNodeForAnchor(lastHitAnchor!)
        }
        booksCollection.reloadData()
    }
}

/*
 Action Sheet
 */

extension MainVC {
    @IBAction func addActions(_ sender: Any) {
        showAttachmentActionSheet(sender as! UIButton)
    }

    func showAttachmentActionSheet(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "add a picture...", message: "", preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in self.fromCamera() }))

        actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { _ in self.fromPhotos() }))

        actionSheet.addAction(UIAlertAction(title: "Files", style: .default, handler: { _ in self.fromFiles() }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))


        actionSheet.popoverPresentationController?.sourceView = sender
        actionSheet.popoverPresentationController?.sourceRect = sender.bounds
        actionSheet.popoverPresentationController?.permittedArrowDirections = .up


        self.present(actionSheet, animated: true, completion: nil)
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
