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

    var refImgs: [ARReferenceImage]
    var lowImgs: [UIImage]
    
    init() {
        refImgs = [ARReferenceImage]()
        lowImgs = [UIImage]()
        fetchAllBooks { (_) in }

    }


    /*
     get the book from an anchor
     */
    func getBookForImageAnchor(_ imgAnchor: ARImageAnchor) -> Book? {
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
        return fetchBookById(id: id, completion: { (completed) in })
    }

    func getBookForId(_ id: UUID) -> Book? {
        return fetchBookById(id: id, completion: { (completed) in })
    }



    /*
     get a book's tasks sorted by date
    */
    func getSortedTasks(_ book: Book) -> [Task] {
        return (book.tasks as! Set<Task>).sorted(by: { (taskA, taskB) -> Bool in
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
extension BooksManager {


    /******************
     ------------------
     Fetch from core data
     ------------------
     ******************/


    func fetchAllBooks(completion: (Bool)->()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        let fetchRequest = NSFetchRequest<Book>(entityName: "Book")

        // targets for this functions
        refImgs = [ARReferenceImage]()
        lowImgs = [UIImage]()

        do {
            let books = try managedContext.fetch(fetchRequest)

            for book in books.sorted(by: { (bookA, bookB) -> Bool in
                return bookA.timestamp! > bookB.timestamp!
            }) {
                // in core data, books are stored as uiimages
                guard let img = UIImage(data: book.refImage!) else { continue }

                // ar reference from uiimage
                let arImg = ARReferenceImage(img.cgImage!, orientation: .up, physicalWidth: 0.2)
                arImg.name = book.id?.uuidString
                let lowImg = img.resized(withPercentage: 0.1)!
                refImgs.append(arImg)
                lowImgs.append(lowImg)

                // refToBooks[arImg] = book
            }
            print("Successfully fethced ALL books!")
            completion(true)
        } catch {
            debugPrint("Faild to fetch ALL book: \(error.localizedDescription)")
            completion(false)
        }
    }

    /*
     get a book from uuid
     */
    func fetchBookById(id: UUID, completion: (Bool) -> () ) -> Book? {
        guard let mc = appDelegate?.persistentContainer.viewContext
        else {
            print("Fetching book by uuid went wrong!")
            return nil
        }
        let fetchedRequest = NSFetchRequest<Book>(entityName: "Book")
        fetchedRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let book = try mc.fetch(fetchedRequest)[0]
            print("Successfully fetched book by uuid!")
            completion(true)
            return book
        } catch {
            debugPrint("Faild to fetch data: \(error.localizedDescription)")
            completion(false)
            return nil
        }

    }


    /******************
     ------------------
     Store to core data
     ------------------
     ******************/
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

    /*
     insert data
    */
    func insertBook(refImg: UIImage,
                 tasksList: [(Date, String, Int)],
                 _ completion: (_ finished: Bool)->()) {

        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        // to core data
        var newTasks = Set<Task>()
        for (date, description, priority) in tasksList {
            let newTask = Task(context: managedContext)
            newTask.deadline = date
            newTask.content = description
            newTask.priority = Int16(priority)
            newTask.timestamp = Date()
            newTasks.insert(newTask)
        }

        let book = Book(context: managedContext)
        book.addToTasks(NSSet(set: newTasks))
        book.refImage = refImg.pngData()
        book.timestamp = Date()
        book.id = UUID()

        trySaveContext(managedContext, completion)

    }



    // update task for an existing book
    func insertForBook(book: Book,
                       task: (Date, String, Int),
                       _ completion: (_ finished: Bool)->()) {

        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        // to core data

        let newTask = Task(context: managedContext)
        newTask.deadline = task.0
        newTask.content = task.1
        newTask.priority = Int16(task.2)
        newTask.timestamp = Date()

        book.addToTasks(newTask)

        trySaveContext(managedContext, completion)


    }




    /*
     delete data
     */
    // delete task for an existing book
    func deleteTask(task: Task, _ completion: (_ finished: Bool)->()) {

        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        managedContext.delete(task)

        trySaveContext(managedContext, completion)

    }

    // delete task for an existing book
    func deleteBook(book: Book, _ completion: (_ finished: Bool)->()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        for task in book.tasks as! Set<Task> {
            deleteTask(task: task) { (_) in }
        }
        managedContext.delete(book)
        trySaveContext(managedContext, completion)
        fetchAllBooks { (_) in }
    }



}




