//
//  ExtView.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/5/19.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit


@IBDesignable
class ExtView: UIView {

    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
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

    @IBInspectable
    public var borderWidth: CGFloat = 1 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }

    @IBInspectable
    public var borderColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
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



    func createHole(_ hole: CGPath) {
        // TODO: reject open Path
        let p = CGMutablePath()
        p.addRect(self.bounds)
        p.addPath(hole)
        let s = CAShapeLayer()
        s.path = p
        s.fillRule = CAShapeLayerFillRule.evenOdd
        layer.mask = s
    }


}


