//
//  MainVC+AddItems.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/7/9.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

enum SlideUpState {
    case addItem, viewItem
}

extension MainVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate {


    @IBAction func addBtnTapped(_ sender: Any) {
        // create a slide up view
        self.presentSlideUp(state: .addItem)

    }

}



extension MainVC {
    internal func presentSlideUp(state: SlideUpState) {
        var rootVC: UIViewController

        switch state {
        case .addItem:
            rootVC = AddItemVC(nibName: "AddItemView", bundle: nil)
        case .viewItem:
            rootVC = ShowItemsVC(nibName: "ShowItemsView", bundle: nil)
        }

        let slideUpNavVC = SlideUpNavVC(rootViewController: rootVC)

        slideUpNavVC.slideUpDelegate = self
        slideUpNavVC.navigationBar.isHidden = true

        addChild(slideUpNavVC)
        slideUpNavVC.view.frame = slideUpViewFrame
        view.addSubview(slideUpNavVC.view)
        slideUpNavVC.didMove(toParent: self)

        UIView.animate(withDuration: 0.3) {
            // push up the slide up view
            slideUpNavVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY - 240, width: self.view.frame.width, height: 240)
             self.focus(on: false)
        }
    }


}


extension MainVC: SlideUpVCDelegate {
    func onSlideUpViewDismiss() {
        UIView.animate(withDuration: 0.1) {
            self.focus(on: true)
        }
    }
}



extension MainVC {

    func onOtherVCShow() {
        UIView.animate(withDuration: 0.1) {
            self.focus(on: false)
        }
    }

    func onOtherVCDismiss() {
        UIView.animate(withDuration: 0.1) {
            self.focus(on: true)
        }
    }

    internal func focus(on: Bool) {
        addBtnView.alpha = on ? 1 : 0
        sceneView.toggleDarkMask(on: !on)
    }


    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        onOtherVCShow()
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }


}
