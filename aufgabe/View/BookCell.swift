//
//  BookCell.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/5/28.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit


protocol BookCellDelegate: class {
    func cellWillEdit(with id: UUID)
    func cellWillDelete(with id: UUID)
}

class BookCell: UICollectionViewCell {
    @IBOutlet weak var bookImg: UIImageView!
    @IBOutlet weak var actionView: UIView!


    var cellID: UUID!

    weak var delegate: BookCellDelegate?

    override func awakeFromNib() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        actionView.addGestureRecognizer(tapGesture)
    }


    func configBookCell(img: UIImage, id: UUID, delegate: BookCellDelegate) {
        bookImg.image = img
        cellID = id
        self.delegate = delegate

    }

    func toggleActions(_ turnOn: Bool) {
        if turnOn == true && actionView.isHidden == true {
            self.actionView.alpha = 0.0
            self.actionView.isHidden = false
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                self.actionView.alpha = 1.0
            }) { (isCompleted) in }
        } else if turnOn == false && actionView.isHidden == false  {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                self.actionView.alpha = 0.0
            }) { (isCompleted) in
                self.actionView.isHidden = true
            }
        }
    }


    @objc func onTap(_ sender: UIView) {
        toggleActions(false)
    }


    @IBAction func deleteBtnTapped(_ sender: Any) {
        toggleActions(false)
        delegate?.cellWillDelete(with: self.cellID)
    }

    @IBAction func editBtnTapped(_ sender: Any) {
        toggleActions(false)
        delegate?.cellWillEdit(with: self.cellID)
    }


}



