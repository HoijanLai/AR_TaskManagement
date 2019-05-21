//
//  GlassTextField.swift
//
//  Created by Hoijan Lai on 2018/11/20.
//  Copyright © 2018 Hoijan Lai. All rights reserved.
//

import UIKit

@IBDesignable
class GlassTextField: UITextField {

    override func draw(_ rect: CGRect) {
        clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }

    func customizeView() {
        backgroundColor = #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 0.2479398545)
        layer.cornerRadius = 5.0
        
        if let p = placeholder {
            let place = NSAttributedString(string: p, attributes: [.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)])
            attributedPlaceholder = place
            textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        let paddingView = UIView(frame: CGRect(x:0, y:0, width:10, height:self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }

}
