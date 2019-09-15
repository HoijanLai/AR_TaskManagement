//
//  EditVC.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/9/6.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

enum EditState {
    case create, update
}

protocol EditVCDelegate: class {
    func onCreateData(_ date: Date, _ content: String)
    func onUpdateData(at indexPath: IndexPath, _ date: Date, _ content: String)

}

class EditVC: UIViewController {


    weak var delegate: EditVCDelegate?

    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var descriptionText: UITextField!
    private var indexPath: IndexPath!


    private var date: Date = Date()
    private var content: String = ""
    private var state: EditState = .create

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getTapped(_:)))
        view.addGestureRecognizer(tapGesture)


    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        self.view.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1
        }
    }

    func configView(date: Date,
                    content: String,
                    at indexPath: IndexPath,
                    state: EditState = .update) {
        self.date = date
        self.content = content
        self.indexPath = indexPath
        self.state = state

    }


    private func updateUI() {
        datePick.setValue(UIColor.white, forKey: "textColor")
        datePick.setDate(date, animated: false)
        descriptionText.text = content
    }



    @objc
    func getTapped(_ sender: UITapGestureRecognizer) {
        // present the task view (as edit is cancel)
        toTaskVC()

    }



    @IBAction func confirmBtnTapped(_ sender: UIButton) {
        let content = descriptionText.text  ??  ""
        let date = datePick.date

        switch state {
        case .create:
            delegate?.onCreateData(date, content)
        case .update:
            delegate?.onUpdateData(at: indexPath, date, content)
        }
        toTaskVC()
    }

    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        toTaskVC()
    }


    private func toTaskVC() {
        guard let nav = navigationController else { return }


        UIView.animate(withDuration: 0.1, animations: {
            self.view.alpha = 0
        }) { (_) in
            nav.popToRootViewController(animated: false)
        }
    }


}
