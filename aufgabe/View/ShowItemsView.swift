//
//  showItemsView.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/8/12.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

protocol showItemsViewDelegate {
    func backBtnTapped()
    func helpDismiss()
}


class ShowItemsView: UIView {

    @IBOutlet weak var contentView: UIView!


    var delegate: showItemsViewDelegate?

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
        Bundle.main.loadNibNamed("ShowItemsView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }


    @IBAction func backBtnTapped(_ sender: Any) {
        hideUI { (_) in
            self.removeFromSuperview()
            self.delegate?.backBtnTapped()
        }

    }


    @IBAction func cancelBtnTapped(_ sender: Any) {
        delegate?.helpDismiss()
    }

    func presentUI() {
        UIView.animate(withDuration: 0.2) {
            self.alpha=1
        }
    }


    func hideUI(_ completion : ((Bool)->Void)?=nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha=0
        }, completion: completion)

    }





}
