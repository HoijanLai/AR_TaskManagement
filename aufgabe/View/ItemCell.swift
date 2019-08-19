//
//  ItemCell.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/8/12.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCell(itemTitle: String, itemImage: UIImage) {
        title.text = itemTitle
        image.image = itemImage
    }

    

}
