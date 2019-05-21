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
// TODO: 4. UX refine (walkthrough) material and design
//         >>> TODO: allow user to view and delete tasks
//         >>> TODO: change the plane to a more friendly one
//         >>> TODO: disable plane interaction
//         >>> TODO: change plane tap to AR button Tap


import UIKit
import SceneKit
import ARKit

class MainVC: UIViewController, ARSCNViewDelegate {


    @IBOutlet var sceneView: ARSCNView!

    
    // Data
    let booksManager = BooksManager()
    var lastHitAnchor: ARImageAnchor?
    


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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true

        // Actions
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        
        sceneView.addGestureRecognizer(tapGesture)
    }




    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Run the view's session
        sceneView.session.run(booksManager.getTrackingConfig())
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
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
        if let imgAnchor = anchor as? ARImageAnchor {
            if let showNode = booksManager.getGeoForImageAnchor(imgAnchor) {
                showNode.name = "main"
                node.addChildNode(showNode)
            }
        }
        
    }

    func updateNodeForAnchor(_ imgAnchor: ARImageAnchor) {
        guard let node = sceneView.node(for: imgAnchor) else { return }
        guard let oldChild = node.childNode(withName: "main", recursively: true) else { return }
        if let newChild = booksManager.getGeoForImageAnchor(imgAnchor) {
            newChild.name = "main"
            node.replaceChildNode(oldChild, with: newChild)
        }

    }

}
