//
//  EditVCViewController.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/3/11.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit





protocol EditVCDelegate: class {
    func onReceiveData(_ date: Date, _ description: String)
}

class EditVC: UIViewController {

    
    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var contentView: UIView!
    
    var dateData: Date!
    var descriptionData: String!

    weak var delegate: EditVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        datePick.setValue(UIColor.white, forKey: "textColor")
        contentView.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.


        if dateData != nil {
            datePick.date = dateData
        }

        if descriptionData != nil {
            descriptionText.text = descriptionData
        }
    }

    func configView(_ date: Date, _ description: String) {
        dateData = date
        descriptionData = description
    }

    @objc
    func didTap(_ gesture: UIGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func doneBtnTapped(_ sender: Any) {
        descriptionData = descriptionText.text
        dateData = datePick.date
        self.dismiss(animated: true) {
            self.delegate?.onReceiveData(self.dateData, self.descriptionData)
        }
    }

    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}
