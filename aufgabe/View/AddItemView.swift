//
//  addItemView.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/8/12.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

protocol AddItemViewDelegate: class {
    func showItemsBtnTapped()
    func fromCamera()
    func fromFiles()
    func fromPhotos()
    func helpDismiss()
}

class AddItemView: UIView {

    @IBOutlet weak var contentView: UIView!

    /*
     Some init for an xib-based View
    */
    weak var delegate: AddItemViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        extraInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        extraInit()
    }

    init(frame: CGRect, _ hide: Bool=false) {
        super.init(frame: frame)
        extraInit()
        if hide {
            self.alpha=0
        }
    }


    func extraInit() {
        Bundle.main.loadNibNamed("AddItemView", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }


    /*
     transition to view all items view, manage by delegating SlideUpVC
    */
    @IBAction func showItemsBtnTapped(_ sender: Any) {
        hideUI { (_) in
            self.removeFromSuperview()
            self.delegate?.showItemsBtnTapped()
        }

    }

    @IBAction func cancelBtnTapped() {
        delegate?.helpDismiss()
    }

    func presentUI() {
        UIView.animate(withDuration: 0.2) {
            self.alpha=1
        }
    }

    func hideUI(_ completion : ((Bool)->Void)?) {
        UIView.animate(withDuration: 0.2, animations: {
            if (self.alpha == 1) {
                self.alpha = 0
            }
        }, completion: completion)
    }



    @IBAction func camBtnTapped(_ sender: Any) {
        delegate?.fromCamera()
    }

    @IBAction func photoBtnTapped(_ sender: Any) {
        delegate?.fromPhotos()
    }

    @IBAction func fileBtnTapped(_ sender: Any) {
        delegate?.fromFiles()
    }

}




