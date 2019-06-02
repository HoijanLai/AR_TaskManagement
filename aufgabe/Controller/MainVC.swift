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

class MainVC: UIViewController, ARSCNViewDelegate {




    // Data
    let booksManager = BooksManager()


    // AR
    var lastHitAnchor: ARImageAnchor? // this is for editVC data communication



    /*
      UI
     */

    // Main
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var addBtn: UIButton!



    // Book Collection
    @IBOutlet weak var itemBtnView: ExtView!
    @IBOutlet var itemSlideUpView: ExtView!
    @IBOutlet weak var itemContentView: UIView!


    @IBOutlet weak var itemBtnToBottom: NSLayoutConstraint!
    @IBOutlet weak var itemBtnHeight: NSLayoutConstraint!
    var itemBtnUp: Bool = false


    @IBOutlet weak var booksCollection: UICollectionView!





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

        // books
        booksCollection.delegate = self
        booksCollection.dataSource = self


        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true

        // Actions
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        
        sceneView.addGestureRecognizer(tapGesture)




        /*
         UI
        */

        // item button
        initItemBtn()



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
