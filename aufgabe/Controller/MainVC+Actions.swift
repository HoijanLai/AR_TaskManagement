//
//  MainVC+Actions.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/4/20.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension MainVC {


    @objc
    func didTap(_ gesture: UITapGestureRecognizer) {
        let tappedLocation = gesture.location(in: sceneView)

        let hitResults = sceneView.hitTest(tappedLocation, options: [.boundingBoxOnly: true])

        guard let hitNode = hitResults.first?.node else { return }
        guard let hitName = hitNode.name else { return }
        if hitName != "button" { return }
        hitNode.runAction(highlightAction)
        lastHitAnchor = (sceneView.anchor(for: hitNode) as! ARImageAnchor)

        // get the text node binding from a plane (hit test result)

        let TasksVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TasksVC") as! TasksVC
        TasksVC.delegate = self
        TasksVC.modalPresentationStyle = .overFullScreen
        TasksVC.modalTransitionStyle = .crossDissolve
        guard let book = booksManager.getBookForImageAnchor(lastHitAnchor!) else { return }
        TasksVC.initData(book: book)
        self.present(TasksVC, animated: true)


    }

}






