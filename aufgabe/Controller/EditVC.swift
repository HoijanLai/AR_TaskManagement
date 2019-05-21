//
//  EditVCViewController.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/3/11.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit



protocol EditDelegate {
    func onReceiveData(_ date: Date, _ description: String)
}


class EditVC: UIViewController {

    
    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var contentView: UIView!
    
    var dateData: Date!
    var descriptionData: String!

    var delegate: EditDelegate?
    
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

    func configVC(_ date: Date, _ description: String) {
        dateData = date
        descriptionData = description
    }
    
    @objc
    func didTap(_ gesture: UIGestureRecognizer) {
        descriptionData = descriptionText.text
        dateData = datePick.date
        self.dismiss(animated: true) {
            self.delegate?.onReceiveData(self.dateData, self.descriptionData)
        }
    }



}
