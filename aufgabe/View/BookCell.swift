//
//  BookCell.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/5/28.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit


protocol BookCellDelegate {
    func onDeleteCell(at indexPath: IndexPath)
    func onLongPress(at indexpPath: IndexPath)
}

class BookCell: UICollectionViewCell {
    @IBOutlet weak var bookImg: UIImageView!
    @IBOutlet weak var deleteBtnView: UIView!


    var cellID: UUID?
    var delegate: BookCellDelegate?
    var indexPath: IndexPath?

    override func awakeFromNib() {
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.onLongPress(_:))))
        self.deleteBtnView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:))))
    }
    
    func configBookCell(img: UIImage, id: UUID, indexPath: IndexPath, delegate: BookCellDelegate) {
        bookImg.image = img
        cellID = id
        self.indexPath = indexPath
        self.delegate = delegate

    }

    @objc func onLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            deleteBtnView.isHidden = false
        default:
            print("other")
        }


        delegate?.onLongPress(at: indexPath!)
    }

    @objc func onTap(_ sender: UITapGestureRecognizer) {
        deleteBtnView.isHidden = true
    }


    @IBAction func deleteBtnTapped(_ sender: Any) {
        delegate?.onDeleteCell(at: indexPath!)
    }

    func configDeselect() {
        deleteBtnView.isHidden = true
    }
}



