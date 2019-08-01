//
//  MainVC+BooksCollection.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/5/28.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit


extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {


    @IBAction func bookBtnTapped(_ sender: Any) {
        itemSlideUpManager.toggleSlideUpView(in: self.view)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksManager.lowImgs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as? BookCell else { return BookCell() }

        let displayImg = booksManager.lowImgs[indexPath.row]
        let cellID = UUID(uuidString: booksManager.refImgs[indexPath.row].name!)!
        cell.configBookCell(img: displayImg, id: cellID, delegate: self)
        return cell
        
    }

    // select & deselect
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let bookCell = booksCollection.cellForItem(at: indexPath) as? BookCell else {
            return
        }
        bookCell.toggleActions(true)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let bookCell = booksCollection.cellForItem(at: indexPath) as? BookCell else {
            return
        }
        bookCell.toggleActions(false)
    }

}




/*
 Handling Book cell
 */
extension MainVC: BookCellDelegate {

    func cellWillEdit(with id: UUID) {
        guard let book = booksManager.getBookForId(id) else { return }

        let TasksVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TasksVC") as! TasksVC
        TasksVC.delegate = self
        TasksVC.modalPresentationStyle = .overFullScreen
        TasksVC.modalTransitionStyle = .crossDissolve

        TasksVC.initData(book: book)
        self.present(TasksVC, animated: true)
    }

    func cellWillDelete(with id: UUID) {
        guard let book = booksManager.getBookForId(id) else { return }
        booksManager.deleteBook(book: book) { (_) in }
        booksCollection.reloadData()
    }


}

