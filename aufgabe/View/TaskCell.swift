//
//  TaskCell.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/5/19.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit



class TaskCell: UITableViewCell {


    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var delegate: DataChangeDelegate!
    var indexPath: IndexPath!

    var currentTaskDate: Date!
    var currentTaskDescription: String!

    var newTaskDate: Date?
    var newTaskDescription: String?


    func configCell(at indexPath: IndexPath, _ task: Task, _ delegate: DataChangeDelegate) {
        self.delegate = delegate
        self.indexPath = indexPath
        descriptionLabel.text = task.taskDescription!

        let formatter = DateFormatter()
        formatter.dateStyle = .short

        let shortDate = formatter.string(from: task.taskDeadline!)

        dateLabel.text = shortDate
        
        currentTaskDate = task.taskDeadline!
        currentTaskDescription = task.taskDescription!
    }

    @IBAction func editBtnTapped(_ sender: Any) {
        let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditVC") as! EditVC
        editVC.delegate = self
        editVC.modalPresentationStyle = .overFullScreen
        editVC.modalTransitionStyle = .crossDissolve

        editVC.configVC(currentTaskDate!, currentTaskDescription!)


        let activeVC = UIApplication.shared.keyWindow!.rootViewController

        activeVC!.presentedViewController!.present(editVC, animated: true, completion: nil)


    }

    @IBAction func completeBtnTapped(_ sender: Any) {
        delegate?.onDeleteData(at: self.indexPath!)
    }

    @IBAction func delBtnTapped(_ sender: Any) {
        delegate?.onDeleteData(at: self.indexPath!)
    }
}

extension TaskCell: EditDelegate {
    func onReceiveData(_ date: Date, _ description: String) {
        newTaskDate = date
        newTaskDescription = description
        delegate?.onEditData(at: indexPath, newTaskDate!, newTaskDescription!)
    }
}


