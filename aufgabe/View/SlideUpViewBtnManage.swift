//
//  SlideUpViewBtnManage.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/6/9.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit


class SlideUpManager {
    private let btnV: ExtView!
    private let containerV: ExtView!
    private let contentV: UIView!
    private let parentV: UIView!
    private let upPos: CGRect!

    private var vUp: Bool!

    required init(_ btnV: ExtView, _ containerV: ExtView,  _ parentV: UIView) {
        self.btnV = btnV
        self.containerV = containerV
        self.contentV = containerV.subviews[0]
        self.parentV = parentV
        self.upPos = CGRect(x: btnV.frame.minX, y: 0, width: 90, height: 90)
        contentV.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(OnSlideDown(_:))))

        vUp = false
    }


    func ToggleSlideUpView() {
        if !vUp {
            containerV.frame = CGRect(x: 0,
                             y: parentV.frame.height - containerV.frame.height,
                             width: parentV.frame.width,
                             height: containerV.frame.height)

            let p = CGPath(roundedRect: upPos,
                           cornerWidth: 45,
                           cornerHeight: 45,
                           transform: .none)

            containerV.createHole(p)
            parentV.insertSubview(containerV, belowSubview: btnV)

            UIView.animate(withDuration: 3) {
                let dy = (self.upPos.maxY + self.upPos.minY) / 2 - (self.btnV.center.y - self.containerV.frame.minY)
                let dx = (self.upPos.maxX + self.upPos.minX) / 2 - self.btnV.center.x
                self.btnV.transform = CGAffineTransform(translationX: dx, y: dy).scaledBy(x: 1.25, y: 1.25)
                self.btnV.subviews[0].isHidden = true
                self.btnV.backgroundColor = #colorLiteral(red: 0.7795345783, green: 0, blue: 0.3739391565, alpha: 1)
                self.btnV.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.btnV.borderWidth = 0.5
                self.contentV.frame.origin.y = 0
            }
            vUp = true
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentV.frame.origin.y = self.containerV.frame.height
                self.btnV.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).translatedBy(x: 0, y: 0)
                self.btnV.subviews[0].isHidden = false
                self.btnV.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                self.btnV.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                self.btnV.borderWidth = 0
            }) { _ in
                self.containerV.removeFromSuperview()
            }
            vUp = false
        }
    }


    @objc func OnSlideDown(_ sender: UIPanGestureRecognizer) {

        let dy = sender.translation(in: self.contentV).y
        let newY = max(self.contentV.frame.minY + dy, 0)
        self.contentV.frame.origin.y = newY

        let ratioDismiss = self.contentV.frame.minY > 0.3 * self.containerV.frame.height
        let velocityDismiss = sender.velocity(in: self.contentV).y > 100

        switch sender.state {
        case .ended where ratioDismiss || velocityDismiss:
            UIView.animate(withDuration: 0.2, animations: {
                self.contentV.frame.origin.y = self.containerV.frame.height
                self.btnV.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).translatedBy(x: 0, y: 0)
                self.btnV.subviews[0].isHidden = false
                self.btnV.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                self.btnV.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                self.btnV.borderWidth = 0
            }, completion: { _ in
                self.contentV.superview!.removeFromSuperview()
                self.vUp = false
            })
        case .ended:
            UIView.animate(withDuration: 0.2, animations: {
                self.contentV.frame.origin.y = 0
            })
        default:
            break
        }
        sender.setTranslation(.zero, in: self.contentV)
    }


}
