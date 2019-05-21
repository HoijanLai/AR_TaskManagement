//
//  TasksVC.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/5/19.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

protocol DataChangeDelegate {

    func onEditData(at indexPath: IndexPath, _ date: Date, _ description: String)
    func onUpdateData() 
    func onDeleteData(at indexPath: IndexPath)
    
}


class TasksVC: UIViewController {

    @IBOutlet weak var tasksTable: UITableView!


    var booksManager: BooksManager!
    var book: Book!

    var delegate: DataChangeDelegate?


    var lastTappedCell: Int = -1


    override func viewDidLoad() {
        super.viewDidLoad()

        tasksTable.delegate = self
        tasksTable.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasksTable.isHidden = (book.tasks!.count <= 0)
    }

    func initData(booksManager: BooksManager, book: Book) {
        self.booksManager = booksManager
        self.book = book
    }




    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.onUpdateData()
        }
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditVC") as! EditVC
        editVC.delegate = self
        editVC.modalPresentationStyle = .overFullScreen
        editVC.modalTransitionStyle = .crossDissolve
        self.present(editVC, animated: true)
    }

}


/*
 Interaction with TasksCell
 */
extension TasksVC: DataChangeDelegate {
    func onUpdateData() {

    }

    func onDeleteData(at indexPath: IndexPath) {
        self.booksManager.deleteTask(task: (self.booksManager.getSortedTasks(self.book)[indexPath.row]), { (_) in })
        tasksTable.reloadData()
        tasksTable.isHidden = (book.tasks!.count <= 0)
    }

    func onEditData(at indexPath: IndexPath, _ date: Date, _ description: String) {
        let task = self.booksManager.getSortedTasks(self.book)[indexPath.row]
        task.taskDeadline = date
        task.taskDescription = description
        tasksTable.reloadData()
    }
}

extension TasksVC: EditDelegate {
    func onReceiveData(_ date: Date, _ task: String) {
        booksManager.insertForBook(book: book, tasks: (date, task)) { (_) in }
        tasksTable.reloadData()
        tasksTable.isHidden = (book.tasks!.count <= 0)
    }
}


/*
 Table View
 */
extension TasksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book.tasks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as? TaskCell else { return UITableViewCell() }

        cell.configCell(at: indexPath, (booksManager.getSortedTasks(book!)[indexPath.row]), self)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            self.booksManager.deleteTask(task: (self.booksManager.getSortedTasks(self.book)[indexPath.row]), { (_) in })
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            self.tasksTable.isHidden = (self.book.tasks!.count <= 0)
//        }
//        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//
//        return [deleteAction]
//    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastTappedCell = indexPath.row
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.cellForRow(at: indexPath)?.layer.frame.height
        if indexPath.row == lastTappedCell {
            let newHeight = (height == tableView.rowHeight) ? 100: tableView.rowHeight
            lastTappedCell = -1
            return newHeight
        }
        return tableView.rowHeight
    }




}
