//
//  ExtARSCNView.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/6/10.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import ARKit


extension ARSCNView {
    // TODO: BUGGY
    func toggleDarkMask(on: Bool = true) {
        if let subL = self.layer.sublayers {
            for l in subL {
                if l.name == "dark" {
                    if !on { l.removeFromSuperlayer() }
                    return
                }
            }
        }
        if on {
            let darkLayer = CALayer()
            darkLayer.frame = self.frame
            darkLayer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            darkLayer.name = "dark"
            self.layer.addSublayer(darkLayer)
        }
    }
}
