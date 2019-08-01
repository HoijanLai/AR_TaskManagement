//
//  SlideUpViewBtnManage.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/6/9.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit
import ARKit

class SlideUpManager {
    // accepted
    private let btnV: ExtView!
    private let containerV: ExtView!
    private let completion: (Bool) -> Void

    // inferred
    private let contentV: UIView!
    private let upPos: CGRect!
    private let holePath: CGPath!
    var vUp: Bool!

    required init(btnV: ExtView, containerV: ExtView, completion: @escaping ((Bool) -> Void)) {
        self.btnV = btnV
        self.containerV = containerV

        self.completion = completion


        self.vUp = false
        self.contentV = containerV.subviews[0]

        let x = (btnV.frame.minX > containerV.center.x) ? btnV.frame.maxX - 90 : btnV.frame.minX
        self.upPos = CGRect(x: x, y: 0, width: 90, height: 90)
        self.holePath = CGPath(roundedRect: upPos,
                               cornerWidth: 45,
                               cornerHeight: 45,
                               transform: .none)

        self.contentV.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(OnSlideDown(_:))))

    }


    func toggleSlideUpView(in parentView: UIView) {
        if !vUp {
            // dirty preparation for
            containerV.frame = CGRect(x: 0,
                             y: parentView.frame.height - containerV.frame.height,
                             width: parentView.frame.width,
                             height: containerV.frame.height)


            containerV.createHole(self.holePath)

            // make view push up
            parentView.insertSubview(containerV, belowSubview: btnV)
            UIView.animate(withDuration: 0.2, animations: { self.toggleUp() } )

        } else {
            // make view push down
            UIView.animate(withDuration: 0.2,
                           animations: { self.toggleDown() },
                           completion: { _ in self.containerV.removeFromSuperview() } )
        }

    }


    @objc func OnSlideDown(_ sender: UIPanGestureRecognizer) {
        // detect the displacement of the view
        let dy = sender.translation(in: self.contentV).y
        let newY = max(self.contentV.frame.minY + dy, 0)
        self.contentV.frame.origin.y = newY

        let ratioDismiss = self.contentV.frame.minY > 0.3 * self.containerV.frame.height
        let velocityDismiss = sender.velocity(in: self.contentV).y > 100

        switch sender.state {
        case .ended where ratioDismiss || velocityDismiss:
            UIView.animate(withDuration: 0.2,
                           animations: { self.toggleDown() },
                           completion: { _ in self.contentV.superview!.removeFromSuperview() } )
        case .ended:
            UIView.animate(withDuration: 0.2, animations: {
                self.contentV.frame.origin.y = 0
            })
        default:
            break
        }
        sender.setTranslation(.zero, in: self.contentV)
    }



    private func toggleUp() {
        let dy = (self.upPos.maxY + self.upPos.minY) / 2 - (self.btnV.center.y - self.containerV.frame.minY)
        let dx = (self.upPos.maxX + self.upPos.minX) / 2 - self.btnV.center.x
        btnV.transform = CGAffineTransform(translationX: dx, y: dy).scaledBy(x: 1.25, y: 1.25)
        btnV.backgroundColor = #colorLiteral(red: 0.007828700356, green: 0.1290506124, blue: 0.2316633463, alpha: 1)
        contentV.frame.origin.y = 0

        vUp = true
        self.completion(vUp)
    }

    private func toggleDown() {
        contentV.frame.origin.y = self.containerV.frame.height
        btnV.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).translatedBy(x: 0, y: 0)
        btnV.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)

        vUp = false
        self.completion(vUp)
    }

}
