//
//  TaskVC.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/9/6.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

protocol TaskVCDelegate: class {
    func onUpdateData()
}


class TaskVC: UIViewController {


    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var startText: UIStackView!



    var item: Book!
    weak var delegate: TaskVCDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        taskTable.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        taskTable.delegate = self
        taskTable.dataSource = self
        
        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1
        }
        startText.isHidden = (item.tasks!.count > 0)
    }


    func setItem(_ item: Book) {
        self.item = item
    }

}



/******************
 ------------------
    Table View
 ------------------
 ******************/
extension TaskVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasks = item.tasks else {
            print("fail to fetch tasks for this item")
            return 0
        }
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return TaskCell()
        }
        cell.configCell(at: indexPath, itemsManager.getSortedTasks(item)[indexPath.row])
        return cell
    }



    /*
     tableview actions
     */

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {


        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteCell(at: indexPath)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.8)


        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.editCell(at: indexPath)
        }
        editAction.backgroundColor = #colorLiteral(red: 0, green: 0.6947829127, blue: 1, alpha: 0.8)




        return [deleteAction, editAction]
    }







}







/******************
 ------------------
    Actions
 ------------------
 ******************/
extension TaskVC {

    @IBAction func addBtnTapped(_ sender: Any) {
        guard let nav = navigationController else { return }
        let editVC = EditVC(nibName: "EditView", bundle: nil)
        editVC.delegate = self

        // present the editVC
        UIView.animate(withDuration: 0.1, animations: {
            self.view.alpha = 0
        }) { (_) in
            nav.pushViewController(editVC, animated: false)
        }
    }


    @IBAction func cancelBtnTapped(_ sender: Any) {
        guard let nav = navigationController else { return }
        nav.dismiss(animated: false, completion: nil)
    }



    private func deleteCell(at indexPath: IndexPath) {
        itemsManager.deleteTask(task: (itemsManager.getSortedTasks(item)[indexPath.row]), { (_) in })
        taskTable.reloadData()
        startText.isHidden = (item.tasks!.count > 0)
        delegate?.onUpdateData()
    }

    private func editCell(at indexPath: IndexPath) {

        guard let nav = navigationController else { return }

        let editVC = EditVC(nibName: "EditView", bundle: nil)
        editVC.delegate = self

        let task = itemsManager.getSortedTasks(item)[indexPath.row]
        editVC.configView(date: task.deadline!, content: task.content!, at: indexPath, state: .update)


        // present the editVC
        UIView.animate(withDuration: 0.1, animations: {
            self.view.alpha = 0
        }) { (_) in
            nav.pushViewController(editVC, animated: false)
        }


    }


}







/******************
 ------------------
    Delegating
 ------------------
 ******************/


/*
 Update Data from Edit VC
 */
extension TaskVC: EditVCDelegate {
    func onUpdateData(at indexPath: IndexPath, _ date: Date, _ content: String) {
        let task = itemsManager.getSortedTasks(item)[indexPath.row]
        task.deadline = date
        task.content = content
        taskTable.reloadData()
        delegate?.onUpdateData()
    }

    func onCreateData(_ date: Date, _ content: String) {
        itemsManager.insertForItem(item: item, task: (date, content, 0)) { (_) in }
        taskTable.reloadData()
        print("data reloaded")
        startText.isHidden = (item.tasks!.count > 0)
        delegate?.onUpdateData()
    }

}






