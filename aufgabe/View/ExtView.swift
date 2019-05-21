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

    override func awakeFromNib() {
        self.clipsToBounds = true
    }
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }




    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
