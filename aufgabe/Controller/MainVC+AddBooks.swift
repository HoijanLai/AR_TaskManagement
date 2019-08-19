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
        // create a slide up view
        let slideUp = SlideUpVC()
        slideUp.delegate = self

        addChild(slideUp)
        slideUp.view.frame = slideUpViewFrame
        view.addSubview(slideUp.view)
        slideUp.didMove(toParent: self)

        UIView.animate(withDuration: 0.3) {
            // push up the slide up view
            slideUp.view.frame = CGRect(x: 0, y: self.view.frame.maxY - 240, width: self.view.frame.width, height: 240)
        }

    }

}


extension MainVC: SlideUpVCDelegate {
    func onSlideUpViewShow() {
        UIView.animate(withDuration: 0.1
            , animations: {
                self.addBtnView.alpha = 0
        }) { (_) in
            self.sceneView.toggleDarkMask()
        }
    }

    func onSlideUpViewDismiss() {
        UIView.animate(withDuration: 0.1, animations: {
            self.addBtnView.alpha = 1
        }) { (_) in
            self.sceneView.toggleDarkMask()
        }
    }


}
