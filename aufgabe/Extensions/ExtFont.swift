//
//  ExtFont.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/5/25.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit


extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

