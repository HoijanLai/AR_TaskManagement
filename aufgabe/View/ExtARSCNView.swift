//
//  ExtARSCNView.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/6/10.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import ARKit


extension ARSCNView {

    func toggleDarkMask() {
        if let subL = self.layer.sublayers {
            for l in subL {
                if l.name == "dark" {
                    l.removeFromSuperlayer()
                    return
                }
            }
        }

        let darkLayer = CALayer()
        darkLayer.frame = self.frame
        darkLayer.backgroundColor = UIColor.black.cgColor
        darkLayer.opacity = 0.7
        darkLayer.name = "dark"
        self.layer.addSublayer(darkLayer)
    }



}
