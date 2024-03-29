//
//  ExtVFXView.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/6/9.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

@IBDesignable
class ExtVFXView: UIVisualEffectView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            for sv in self.subviews {
                sv.layer.cornerRadius = self.cornerRadius
            }
        }
    }

    @IBInspectable
    public var shadow: Bool = false {
        didSet {
            self.clipsToBounds = !shadow
            self.dropShadow()
        }
    }

    @IBInspectable
    public var shadowColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            self.dropShadow()
        }
    }

    @IBInspectable
    public var shadowOpacity: Float = 0.2 {
        didSet {
            self.dropShadow()
        }
    }

    @IBInspectable
    public var shadowOffsetX: CGFloat = 0.0 {
        didSet {
            self.dropShadow()
        }
    }


    @IBInspectable
    public var shadowOffsetY: CGFloat = 0.0 {
        didSet {
            self.dropShadow()
        }
    }


    @IBInspectable
    public var shadowRadius: CGFloat = 10 {
        didSet {
            self.dropShadow()
        }
    }


    func dropShadow() {
        if shadow {
            let shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = backgroundColor?.cgColor
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowRadius = shadowRadius
            layer.insertSublayer(shadowLayer, at: 0)

        }

    }

}
