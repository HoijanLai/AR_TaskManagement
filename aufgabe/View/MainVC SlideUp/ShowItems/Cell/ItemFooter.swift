//
//  ItemFooter.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/9/7.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

protocol ItemFooterDelegate: class {
    func addItem()
}

class ItemFooter: UICollectionReusableView {

    weak var delegate: ItemFooterDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addBtnTapped() {
        delegate?.addItem()
    }

}
