//
//  ItemsManager.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/3/12.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import Foundation
import CoreData
import ARKit

let appDelegate = UIApplication.shared.delegate as? AppDelegate


class ItemsManager {

    var refImgs: [ARReferenceImage]
    var lowImgs: [UIImage]
    var count: Int {
        return lowImgs.count
    }
    
    init() {
        refImgs = [ARReferenceImage]()
        lowImgs = [UIImage]()
        fetchAllItems { (_) in }

    }


    /*
     get the book from an anchor
     */
    func getItemForImageAnchor(_ imgAnchor: ARImageAnchor) -> Book? {
//        let refImg = imgAnchor.referenceImage
//        if let book = refToBooks[refImg] {
//            return book
//        }
//        return nil
        let refImg = imgAnchor.referenceImage
        guard let id = UUID(uuidString: refImg.name!)
        else {
            print("fail to parse unpack id from anchor")
            return nil
        }
        return fetchItemById(id: id, completion: { (completed) in })
    }

    /*

     */
    func getItemForId(_ id: UUID) -> Book? {
        return fetchItemById(id: id, completion: { (completed) in })
    }






    /*
     get a book's tasks sorted by date
    */
    func getSortedTasks(_ item: Book) -> [Task] {
        return (item.tasks as! Set<Task>).sorted(by: { (taskA, taskB) -> Bool in
            return taskA.deadline! < taskB.deadline!
        })
    }


    func getTrackingConfig() -> ARImageTrackingConfiguration {
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        // Reference images
        configuration.trackingImages = Set(refImgs)
        configuration.maximumNumberOfTrackedImages = refImgs.count
        return configuration
    }

}

/*
 Data Utilities
 */
extension ItemsManager {


    /******************
     ------------------
     Fetch from core data
     ------------------
     ******************/


    func fetchAllItems(completion: ((Bool)->())?=nil) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        let fetchRequest = NSFetchRequest<Book>(entityName: "Book")

        // targets for this functions
        refImgs = [ARReferenceImage]()
        lowImgs = [UIImage]()

        do {
            let items = try managedContext.fetch(fetchRequest)

            for item in items.sorted(by: { (itemA, itemB) -> Bool in
                return itemA.timestamp! > itemB.timestamp!
            }) {
                // in core data, books are stored as uiimages
                guard let img = UIImage(data: item.refImage!) else { continue }

                // ar reference from uiimage
                let arImg = ARReferenceImage(img.cgImage!, orientation: .up, physicalWidth: 0.2)
                arImg.name = item.id?.uuidString
                let lowImg = img.resized(withPercentage: 0.1)!
                refImgs.append(arImg)
                lowImgs.append(lowImg)

                // refToBooks[arImg] = book
            }
            print("Successfully fethced ALL books!")
            completion?(true)
        } catch {
            debugPrint("Faild to fetch ALL book: \(error.localizedDescription)")
            completion?(false)
        }
    }

    /*
     get a book from uuid
     */
    func fetchItemById(id: UUID, completion: ((Bool) -> ())?=nil ) -> Book? {
        guard let mc = appDelegate?.persistentContainer.viewContext
        else {
            print("Fetching book by uuid went wrong!")
            return nil
        }
        let fetchedRequest = NSFetchRequest<Book>(entityName: "Book")
        fetchedRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let item = try mc.fetch(fetchedRequest)[0]
            print("Successfully fetched book by uuid!")
            completion?(true)
            return item
        } catch {
            debugPrint("Faild to fetch data: \(error.localizedDescription)")
            completion?(false)
            return nil
        }

    }


    /******************
     ------------------
     Store to core data
     ------------------
     ******************/
    private func trySaveContext(_ managedContext: NSManagedObjectContext, _ completion: ((Bool) -> ())?=nil) {

        do {
            try managedContext.save()
            print("Successfully saved!")
            completion?(true)
        } catch  {
            debugPrint("Failed to save: \(error.localizedDescription)")
            completion?(false)
        }
    }

    /*
     insert data
    */
    func insertItem(refImg: UIImage,
                    tasksList: [(Date, String, Int)],
                    _ completion: ((Bool)->())?=nil) {

        guard let mc = appDelegate?.persistentContainer.viewContext else { return }

        // to core data
        var newTasks = Set<Task>()
        for (date, description, priority) in tasksList {
            let newTask = Task(context: mc)
            newTask.deadline = date
            newTask.content = description
            newTask.priority = Int16(priority)
            newTask.timestamp = Date()
            newTasks.insert(newTask)
        }

        let item = Book(context: mc)
        item.addToTasks(NSSet(set: newTasks))
        item.refImage = refImg.pngData()
        item.timestamp = Date()
        item.id = UUID()


        let arImg = ARReferenceImage(refImg.cgImage!, orientation: .up, physicalWidth: 0.2)
        arImg.name = item.id?.uuidString
        refImgs.insert(arImg, at: 0)
        lowImgs.insert(refImg.resized(withPercentage: 0.1)!, at: 0)



        trySaveContext(mc, completion)
        print("succefully add book!")


    }



    // update task for an existing book
    func insertForItem(item: Book,
                       task: (Date, String, Int),
                       saveMC: Bool=true,
                       _ completion: ((Bool)->())?=nil) {

        guard let mc = appDelegate?.persistentContainer.viewContext else { return }

        // to core data

        let newTask = Task(context: mc)
        newTask.deadline = task.0
        newTask.content = task.1
        newTask.priority = Int16(task.2)
        newTask.timestamp = Date()

        item.addToTasks(newTask)

        trySaveContext(mc, completion)
        

    }



    func editNameForItem(item: Book,
                         name: String,
                         _ completion: ((Bool)->())?=nil) {
        guard let mc = appDelegate?.persistentContainer.viewContext else { return }

        item.name = name
        // TODO: update for current text
        
        trySaveContext(mc, completion)
    }


    func editCoverForItem(item: Book,
                          image: UIImage,
                          _ indexPath: IndexPath?=nil,
                          _ completion: ((Bool)->())?=nil) {


        if indexPath != nil {
            let arImg = ARReferenceImage(image.cgImage!, orientation: .up, physicalWidth: 0.2)
            arImg.name = item.id?.uuidString
            refImgs[indexPath!.row] = arImg
            lowImgs[indexPath!.row] = image.resized(withPercentage: 0.1)!

        }
        


        guard let mc = appDelegate?.persistentContainer.viewContext else { return }

        item.refImage = image.pngData()
        // TODO: update for current image

        trySaveContext(mc, completion)

    }




    /*
     delete data
     */
    // delete task for an existing book
    func deleteTask(task: Task, _ completion: ((Bool)->())?=nil) {

        guard let mc = appDelegate?.persistentContainer.viewContext else { return }

        mc.delete(task)

        trySaveContext(mc, completion)

    }

    // delete task for an existing book
    func deleteItem(item: Book,
                    _ indexPath: IndexPath?=nil,
                    _ completion: ((Bool)->())?=nil) {

        if indexPath != nil {
            refImgs.remove(at: indexPath!.row)
            lowImgs.remove(at: indexPath!.row)
        }


        guard let mc = appDelegate?.persistentContainer.viewContext else { return }
        for task in item.tasks as! Set<Task> {
            deleteTask(task: task) { (_) in }
        }
        mc.delete(item)
        trySaveContext(mc, completion)


    }



}





