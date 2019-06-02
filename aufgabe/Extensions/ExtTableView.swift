//
//  ExtTableView.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/5/23.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit


extension UITableView {
    func deselectAllItems(_ animated: Bool = true) {
        guard let selectedIndexPaths = indexPathsForSelectedRows else { return }
        for indexPath in selectedIndexPaths { deselectRow(at: indexPath, animated: animated) }
    }
}
