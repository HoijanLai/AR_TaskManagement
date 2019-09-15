//
//  SpinnerVC.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/9/14.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit


enum SpinnerState {
    case over, child
}


class SpinnerVC: UIViewController {
    var spinner = UIActivityIndicatorView(style: .whiteLarge)


    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }



}



class SpinnerManager {


    var spn = SpinnerVC()
    var vc: UIViewController!
    var state: SpinnerState!
    


    init(state: SpinnerState) {
        self.state = state
        vc = UIApplication.shared.keyWindow?.rootViewController
        if (vc != nil) {
            while let pvc = vc.presentingViewController {
                vc = pvc
            }
        }


    }

    func attachSpinnerView() {
        switch self.state {
        case .child?:
            vc.addChild(spn)
            spn.view.frame = vc.view.frame
            vc.view.addSubview(spn.view)
            spn.didMove(toParent: vc)
        case .over?:
            spn.modalTransitionStyle = .crossDissolve
            spn.modalPresentationStyle = .overFullScreen
            vc.present(spn, animated: true, completion: nil)
        case .none:
            break
        }
    }

    func dettachSpinnerView() {
        switch self.state {
        case .child?:
            spn.willMove(toParent: nil)
            spn.view.removeFromSuperview()
            spn.removeFromParent()
        case .over?:
            spn.dismiss(animated: false, completion: nil)
        case .none:
            break
        }

    }

}
