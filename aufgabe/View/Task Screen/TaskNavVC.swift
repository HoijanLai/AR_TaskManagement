//
//  TaskVC.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/8/28.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit



class TaskNavVC: UINavigationController {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.clear
        navigationBar.isHidden = true
        interactivePopGestureRecognizer?.isEnabled = false
        print("called in task")


        view.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 1
        }) 



    }


    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let mainScreen = UIApplication.shared.keyWindow?.rootViewController as? MainVC {
            mainScreen.onOtherVCDismiss()
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }) { (_) in
            super.dismiss(animated: flag, completion: completion)
        }

    }


}






