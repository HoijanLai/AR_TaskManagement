//
//  TaskCell.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/5/19.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

//protocol TaskCellDelegate: class {
//    func onDeleteData(at indexPath: IndexPath)
//    func onEditData(at indexPath: IndexPath, _ date: Date, _ description: String)
//}

class TaskCell: UITableViewCell {


    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

//    weak var delegate: TaskCellDelegate?
    var indexPath: IndexPath!




    func configCell(at indexPath: IndexPath, _ task: Task) {
        self.indexPath = indexPath
        descriptionLabel.text = task.content

        let formatter = DateFormatter()
        formatter.dateStyle = .short

        let shortDate = formatter.string(from: task.deadline!)
        dateLabel.text = shortDate
    }



    



//    func toggleActions(_ turnOn: Bool) {
//        if turnOn == true && extView.isHidden == true {
//            extView.alpha = 0.0
//            self.extView.isHidden = false
//            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
//                self.extView.alpha = 1.0
//            }) { (isCompleted) in }
//        } else if turnOn == false && extView.isHidden == false  {
//            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
//                self.extView.alpha = 0.0
//            }) { (isCompleted) in
//                self.extView.isHidden = true
//            }
//        }
//
//    }

//    @IBAction func editBtnTapped(_ sender: Any) {
//        toggleActions(false)
//        let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditVC") as! EditVC
//        editVC.delegate = self
//        editVC.modalPresentationStyle = .overFullScreen
//        editVC.modalTransitionStyle = .crossDissolve
//
//        editVC.configView(currentTaskDate!, currentTaskDescription!)
//
//
//        let activeVC = UIApplication.shared.keyWindow!.rootViewController
//
//        activeVC!.presentedViewController!.present(editVC, animated: true, completion: nil)
//
//
//    }
//
//    @IBAction func completeBtnTapped(_ sender: Any) {
//        toggleActions(false)
//        delegate?.onDeleteData(at: self.indexPath!)
//    }
//
//    @IBAction func cancelBtnTapped(_ sender: Any) {
//        toggleActions(false)
//    }
}

//extension TaskCell: EditVCDelegate {
//    func onReceiveData(_ date: Date, _ description: String) {
//        // newTaskDate = date
//        // newTaskDescription = description
//        // delegate?.onEditData(at: indexPath, newTaskDate!, newTaskDescription!)
//    }
//}


