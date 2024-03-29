//
//  MainVC.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/3/8.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

// function :
// >>>DONE: 1. tap and edit test
//         >>> DONE  1.5. Detect which one get tapped?
// >>>DONE: 2. functionalities to add books
// TODO: 3. user data management ( login, icloud, data storage )
//         >>> DONE  3.1 change the location where we find picture template (from static
//                       assets to an static data source)
//         >>> TODO  3.2 duplicated image management
//


// STAGE TWO: Bussiness Logics
// TODO: 4. UX refine (walkthrough) material and design
//         >>> DONE: allow user to view and delete tasks
//         >>> DONE: change the plane to a more friendly one
//         >>> DONE: disable plane interaction
//         >>> DONE: change plane tap to AR button Tap
//         >>> TODO: LONG Pressed view full image
//         >>> DONE: Select Book and edit tasks


// TODO: 5. Bussiness Logics
//         >>> TODO: Secret
//         >>> TODO: Password to show secret items
//         >>> TODO: books with independent password
//         >>> TODO: Data Package Share


// TODO: 6. UI Refine
//

import UIKit
import SceneKit
import ARKit

// Data
let itemsManager = ItemsManager()


class MainVC: UIViewController, ARSCNViewDelegate {

    // AR
    var lastHitAnchor: ARImageAnchor? // this is for editVC data communication

    /*
      UI
     */
    // Main
    @IBOutlet weak var sceneView: ARSCNView!


    // Add Books
    @IBOutlet weak var addBtnView: ExtView!
    @IBOutlet weak var addBtnToBottom: NSLayoutConstraint!
    @IBOutlet weak var addBtnHeight: NSLayoutConstraint!
    var slideUpViewFrame: CGRect!



    // Animation Scheme
    var highlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.15),
            .fadeOpacity(to: 0.15, duration: 0.15),
            .fadeOpacity(to: 0.85, duration: 0.15),
            .fadeOpacity(to: 0.15, duration: 0.15),
            .fadeOpacity(to: 0.85, duration: 0.15),
            .fadeOpacity(to: 1.00, duration: 0.15)
            ])
    }




    /*
     *******************
       Initializations
     *******************
    */
    fileprivate func initActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }

    fileprivate func initUI() {
        slideUpViewFrame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 240)
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        initActions()
        initUI()

    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Run the view's session
        sceneView.session.run(itemsManager.getTrackingConfig())
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }






    
    /*
     *************
       AR Stuffs
     *************
     */
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        // DONE: define which image for this anchor
        // DONE: render corressponding text for this image
        guard let imgAnchor = anchor as? ARImageAnchor else { return }
        if let showNode = itemsManager.getGeoForImageAnchor(imgAnchor) {
            showNode.name = "main"
            node.addChildNode(showNode)
        }
    }



}









/*
 **************************
    Segue : Task Screen
 **************************
 */

extension MainVC: TaskVCDelegate {

    func onUpdateData() {
        sceneView.session.run(itemsManager.getTrackingConfig(), options: .resetTracking)
        if lastHitAnchor != nil {
            updateNodeForAnchor(lastHitAnchor!)
        }
    }
}






