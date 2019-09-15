//
//  SlideUpVC.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/8/12.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

protocol SlideUpVCDelegate: class {
    func onSlideUpViewDismiss()
}

class SlideUpNavVC: UINavigationController {

    weak var slideUpDelegate: SlideUpVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onUserSlideDown(_:)))
        view.addGestureRecognizer(panRecognizer)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactivePopGestureRecognizer?.isEnabled = false
    }



}
















/*
 Dismiss the SlideUp
 */
extension SlideUpNavVC {

    func slideDown() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = self.view.frame.minY + self.view.frame.height
        }) { (_) in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        slideDown()
        self.slideUpDelegate?.onSlideUpViewDismiss()
        super.dismiss(animated: flag, completion: completion)
    }

    @objc
    func onUserSlideDown(_ sender: UIPanGestureRecognizer) {
        if view.subviews.isEmpty { return }

        let sv = view.subviews[0]
        // detect the displacement of the view
        let dy = sender.translation(in: view).y
        let newY = max(sv.frame.origin.y + dy, 0)
        sv.frame.origin.y = newY

        let ratioDismiss = sv.frame.minY > 0.3 * view.frame.height
        let velocityDismiss = sender.velocity(in: view).y > 100

        switch sender.state {
        case .ended where ratioDismiss || velocityDismiss:
            self.dismiss(animated: true, completion: nil)
        case .ended:
            UIView.animate(withDuration: 0.2, animations: {
                sv.frame.origin.y = 0
            })
        default:
            break
        }
        sender.setTranslation(.zero, in: view)
    }

}

