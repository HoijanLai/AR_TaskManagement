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


        // 
        if !children.isEmpty {
            for c in children {
                c.dismiss(animated: true, completion: nil)
            }
        }




        // if sceneView is touchable
        let tappedLocation = gesture.location(in: sceneView)

        let hitResults = sceneView.hitTest(tappedLocation, options: [.boundingBoxOnly: true])

        guard let hitNode = hitResults.first?.node else { return }
        guard let hitName = hitNode.name else { return }
        if hitName != "button" { return }
        hitNode.runAction(highlightAction)
        lastHitAnchor = (sceneView.anchor(for: hitNode) as! ARImageAnchor)

        // get the text node binding from a plane (hit test result)
        guard let item = itemsManager.getItemForImageAnchor(lastHitAnchor!) else { return }

        let taskVC = TaskVC(nibName: "TaskView", bundle: nil)
        taskVC.setItem(item)
        taskVC.delegate = self

        let taskScreen = TaskNavVC(rootViewController: taskVC)
        

        taskScreen.modalPresentationStyle = .overCurrentContext
        taskScreen.modalTransitionStyle = .crossDissolve

        present(taskScreen, animated: true)


    }



    func updateNodeForAnchor(_ imgAnchor: ARImageAnchor) {
        guard let node = sceneView.node(for: imgAnchor) else { return }
        guard let oldChild = node.childNode(withName: "main", recursively: true) else { return }
        if let newChild = itemsManager.getGeoForImageAnchor(imgAnchor) {
            newChild.name = "main"
            node.replaceChildNode(oldChild, with: newChild)
        }

    }

}






