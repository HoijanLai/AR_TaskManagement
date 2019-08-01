//
//  TasksVC.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/5/19.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit


protocol TaskVCDelegate: class {
    func onUpdateData()
}


class TasksVC: UIViewController {

    @IBOutlet weak var tasksTable: UITableView!
    @IBOutlet weak var welcomeText: UIStackView!

    var book: Book!

    weak var delegate: TaskVCDelegate?



    override func viewDidLoad() {
        super.viewDidLoad()

        tasksTable.delegate = self
        tasksTable.dataSource = self


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        welcomeText.isHidden = (book.tasks!.count > 0)
    }

    func initData(book: Book) {
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
        tasksTable.reloadData()
        self.present(editVC, animated: true)
    }

}


/*
 Interaction with TasksCell
 */
extension TasksVC: TaskCellDelegate {
    func onDeleteData(at indexPath: IndexPath) {
        booksManager.deleteTask(task: (booksManager.getSortedTasks(self.book)[indexPath.row]), { (_) in })
        tasksTable.reloadData()
        welcomeText.isHidden = (book.tasks!.count > 0)
    }

    func onEditData(at indexPath: IndexPath, _ date: Date, _ description: String) {
        let task = booksManager.getSortedTasks(self.book)[indexPath.row]
        task.deadline = date
        task.content = description
        tasksTable.reloadData()
    }
}

extension TasksVC: EditVCDelegate {
    func onReceiveData(_ date: Date, _ task: String) {
        booksManager.insertForBook(book: book, task: (date, task, 0)) { (_) in }
        tasksTable.reloadData()
        welcomeText.isHidden = (book.tasks!.count > 0)
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


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taskCell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
        taskCell.toggleActions(true)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let taskCell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
        taskCell.toggleActions(false)
    }

}
