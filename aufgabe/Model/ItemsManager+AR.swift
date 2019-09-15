//
//  ItemsManager+AR.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/5/29.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import Foundation
import CoreData
import ARKit

/*
 AR Utilities
 */
extension ItemsManager {


    // build ar geometry
    func getGeoForImageAnchor(_ imgAnchor: ARImageAnchor) -> SCNNode? {
        let refImg = imgAnchor.referenceImage

        if let item = getItemForImageAnchor(imgAnchor) {
            let refSize = refImg.physicalSize

            let textNode = buildARTaskNode(item: item)
            textNode.position.x = -Float(refSize.width / 2)
            textNode.position.z = -Float(refSize.height / 2)

            let showNode = SCNNode()
            // showNode.addChildNode(buildARPlane(refSize))
            showNode.addChildNode(build3DButton(refSize))
            showNode.addChildNode(textNode)
            return showNode
        }

        return nil
    }


    // text
    func buildARTaskNode(item: Book) -> SCNNode {

        let formatter = DateFormatter()
        formatter.dateStyle = .short



        let resultNode = SCNNode()

        for (n, item) in getSortedTasks(item).enumerated() {


            /*
             BUILD GEOMETRIES
             */
            // Texts
            let shortDate = "Date: " + formatter.string(from: item.deadline!)
            let taskDescription = item.content!


            // Geometry
            let dateGeo = SCNText(string: shortDate, extrusionDepth: 0.15)
            let dscGeo = SCNText(string: taskDescription, extrusionDepth: 0.15)

            dateGeo.flatness = 0
            dscGeo.flatness = 0
            dateGeo.font = UIFont(name: "Copperplate", size: 0.8)
            dscGeo.font = UIFont(name: "PingFang HK", size: 1.2)


            // Materials for Geometries
            let material = SCNMaterial()
            material.diffuse.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            dateGeo.materials = [material]

            let dscMaterial = SCNMaterial()
            dscMaterial.diffuse.contents = UIColor(red: 160/255, green: 180/255, blue: 90/255, alpha: 1)

            dscMaterial.reflective.intensity = 0
            dscGeo.materials = [dscMaterial]



            /*
             BUILD NODES
             */

            // Node for Geometries
            let dateNode = SCNNode(geometry: dateGeo)
            let dscNode = SCNNode(geometry: dscGeo)


            // Light for nodes
            let light = SCNLight()
            light.type = .ambient
            light.intensity = 300.0
            light.castsShadow = true

            dateNode.light = light


            // Transformations
            dscNode.eulerAngles.x = -.pi/4
            dateNode.eulerAngles.x = -.pi/2

            let dscHeight = dscNode.boundingBox.max.y - dscNode.boundingBox.min.y
            dateNode.position.y = dscNode.boundingBox.max.y
            dateNode.position.z = -Float(dscHeight*cos(.pi/4))



            // Assembling
            let taskNode = SCNNode()
            taskNode.addChildNode(dateNode)
            taskNode.addChildNode(dscNode)
            taskNode.scale = SCNVector3(0.01, 0.01, 0.01)
            taskNode.position.z = 0.03*Float(n)

            taskNode.castsShadow = true

            resultNode.addChildNode(taskNode)
        }

        // present the text
        resultNode.name = "tasks"
        return resultNode

    }



    /*
      plane
    */
    func buildARPlane(_ refSize: CGSize) -> SCNNode {
        let plane = SCNPlane(width:  refSize.width,
                             height: refSize.height)

        plane.materials.first?.diffuse.contents = UIColor(red: 0.1, green: 0.3, blue: 0.7, alpha: 0.3)

        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 0.8
        planeNode.name = "plane"
        return planeNode
    }


    /*
        button
     TODO: handle errors
    */
    func build3DButton(_ refSize: CGSize) -> SCNNode {

        let x = refSize.width/2 - 0.03
        let z = refSize.height/2 - 0.03

        let buttonNode = SCNScene(named: "../art.scnassets/button.scn")?.rootNode
        buttonNode?.scale = SCNVector3(0.012, 0.02, 0.012)
        buttonNode?.position = SCNVector3(x, 0.01, z)
        buttonNode!.name = "button"

        var jumpAction: SCNAction {
            var actionSequence = [SCNAction]()
            for i in 0 ... 11 {
                let rad = Float(i) * .pi / 5.0
                let y = 0.02 - 0.01 * cos(rad)
                actionSequence.append(SCNAction.move(to: SCNVector3(x, CGFloat(y), z), duration: 0.06))
            }
            actionSequence.append(.move(to: SCNVector3(x, 0.01, z), duration: 0.8))
            return .repeatForever(.sequence(actionSequence))

        }
        buttonNode!.runAction(jumpAction)
        return buttonNode!
    }


}
