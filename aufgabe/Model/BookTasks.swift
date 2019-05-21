//
//  BookTasks.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/3/12.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import Foundation
import CoreData
import ARKit

let appDelegate = UIApplication.shared.delegate as? AppDelegate


class BooksManager {
    private var refToBooks: [ARReferenceImage: Book]

    init() {
        refToBooks = [ARReferenceImage: Book]()
        fetchData { (_) in }
    }

    func getReferences() -> Set<ARReferenceImage>? {
        return Set<ARReferenceImage>(refToBooks.keys)
    }

    func getBookForImageAnchor(_ imgAnchor: ARImageAnchor) -> Book? {
        let refImg = imgAnchor.referenceImage
        if let book = refToBooks[refImg] {
            return book
        }

        return nil
    }


    // get a book's tasks sorted by date
    func getSortedTasks(_ book: Book) -> [Task] {
        return (book.tasks as! Set<Task>).sorted(by: { (taskA, taskB) -> Bool in
            return taskA.taskDeadline! < taskB.taskDeadline!
        })
    }


    // build ar geometry
    func getGeoForImageAnchor(_ imgAnchor: ARImageAnchor) -> SCNNode? {
        let refImg = imgAnchor.referenceImage

        if let book = refToBooks[refImg] {
            let refSize = refImg.physicalSize

            let textNode = buildARTaskNode(book: book)
            textNode.position.x = -Float(refSize.width / 2)
            textNode.position.z = -Float(refSize.height / 2)

            let showNode = SCNNode()
            showNode.addChildNode(buildARPlane(refSize))
            showNode.addChildNode(textNode)
            return showNode
        }
        
        return nil
    }


    func getTrackingConfig() -> ARImageTrackingConfiguration {
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        // Reference images
        let trackingSet = self.getReferences() ?? Set<ARReferenceImage>()
        configuration.trackingImages = trackingSet
        configuration.maximumNumberOfTrackedImages = trackingSet.count
        return configuration
    }



}

/*
 Data Utilities
 */
extension BooksManager {

    private func trySaveContext(_ managedContext: NSManagedObjectContext, _ completion: (Bool) -> ()) {
        do {
            try managedContext.save()
            print("Successfully saved!")
            completion(true)
        } catch  {
            debugPrint("Failed to save: \(error.localizedDescription)")
            completion(false)
        }
    }

    // data fetching utilities
    private func fetchData(completion: (Bool)->()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        let fetchRequest = NSFetchRequest<Book>(entityName: "Book")

        do {
            let books = try managedContext.fetch(fetchRequest)
            print("Successfully fethced!")
            collectReferences(books: books)
            completion(true)
        } catch {
            debugPrint("Faild to fetch data: \(error.localizedDescription)")
            completion(false)
        }
    }

    private func collectReferences(books: [Book]) {
        for book in books {
            guard let img = UIImage(data: book.refImage!)?.cgImage else { continue }
            let arImg = ARReferenceImage(img, orientation: .up, physicalWidth: 0.2)
            refToBooks[arImg] = book
        }
    }




    // store new data to core data
    func newData(refImg: UIImage,
                 tasksList: [(Date, String)],
                 _ completion: (_ finished: Bool)->()) {

        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        // to core data
        let book = Book(context: managedContext)
        book.refImage = refImg.pngData()

        var tasks = Set<Task>()
        for (date, description) in tasksList {
            let task = Task(context: managedContext)
            task.taskDeadline = date
            task.taskDescription = description
            tasks.insert(task)
        }

        book.addToTasks(NSSet(set: tasks))

        trySaveContext(managedContext, completion)

        // to current data
        let arImg = ARReferenceImage(refImg.cgImage!, orientation: .up, physicalWidth: 0.2)
        refToBooks[arImg] = book
    }



    // update task for an existing book
    func insertForBook(book: Book,
                       tasks: (Date, String),
                       _ completion: (_ finished: Bool)->()) {

        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        // to core data

        let task = Task(context: managedContext)
        task.taskDeadline = tasks.0
        task.taskDescription = tasks.1

        book.addToTasks(task)

        trySaveContext(managedContext, completion)

    }


    // delete task for an existing book
    func deleteTask(task: Task, _ completion: (_ finished: Bool)->()) {

        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        managedContext.delete(task)

        trySaveContext(managedContext, completion)
    }


}


/*
 AR Utilities
 */
extension BooksManager {

    // text
    private func buildARTaskNode(book: Book) -> SCNNode {

        let formatter = DateFormatter()
        formatter.dateStyle = .short

        let resultNode = SCNNode()
        for (n, item) in getSortedTasks(book).enumerated() {
            print(item.taskDeadline!)
            print(item.taskDescription!)
            let taskNode = SCNNode()

            // Texts
            let shortDate = formatter.string(from: item.taskDeadline!)
            let taskDescription = item.taskDescription!


            // Formatting
            let dateGeo = SCNText(string: shortDate, extrusionDepth: 0.1)
            let dscGeo = SCNText(string: taskDescription, extrusionDepth: 0.1)
            dateGeo.font = UIFont(name: "Avenir", size: 1)
            dscGeo.font = UIFont(name: "Avenir", size: 2)


            // Material
            let material = SCNMaterial()
            material.diffuse.contents = UIColor(red: 160/255, green: 160/255, blue: 75/255, alpha: 1.0)
            material.emission.contents = UIColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1.0)
            dateGeo.materials = [material]
            dscGeo.materials = [material]

            // Node for Geometries
            let dateNode = SCNNode(geometry: dateGeo)
            let dscNode = SCNNode(geometry: dscGeo)

            dscNode.eulerAngles.x = -.pi/4
            dateNode.position.y = 1.7
            dateNode.position.z = -0.8
            dateNode.eulerAngles.x = -.pi/2


            // Assembling
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



    // plan
    private func buildARPlane(_ refSize: CGSize) -> SCNNode {
        let plane = SCNPlane(width:  refSize.width,
                             height: refSize.height)

        plane.materials.first?.diffuse.contents = UIColor(red: 0.1, green: 0.3, blue: 0.7, alpha: 0.3)

        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 0.8
        planeNode.name = "plane"
        return planeNode
    }
}


