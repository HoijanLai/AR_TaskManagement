//
//  MainVC+BooksCollection.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/5/28.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit


extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, BookCellDelegate {


    func initItemBtn() {
        itemContentView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(OnSlideDown(_:))))
    }

    @IBAction func bookBtnTapped(_ sender: Any) {
        if !itemBtnUp {
            itemSlideUpView.frame = CGRect(x: 0,
                                           y: view.frame.height - itemSlideUpView.frame.height,
                                           width: view.frame.width,
                                           height: itemSlideUpView.frame.height)


            let p = CGPath(roundedRect: CGRect(x: 25, y: 0, width: 90, height: 90),
                           cornerWidth: 45,
                           cornerHeight: 45,
                           transform: .none)

            itemSlideUpView.createHole(p)
            view.insertSubview(itemSlideUpView, belowSubview: itemBtnView)


            self.itemBtnView.cornerRadius = 40
            self.itemBtnToBottom.constant = self.itemSlideUpView.frame.height - 5
            self.itemBtnHeight.constant = 80

            itemContentView.frame.origin.y = itemSlideUpView.frame.height
            UIView.animate(withDuration: 0.3) {
                self.itemContentView.frame.origin.y = 0
                self.view.layoutIfNeeded()
            }
            itemBtnUp = true
        } else {
            self.itemBtnView.cornerRadius = 32
            self.itemBtnToBottom.constant = 96
            self.itemBtnHeight.constant = 64
            UIView.animate(withDuration: 0.2, animations: {
                self.itemContentView.frame.origin.y = self.itemSlideUpView.frame.height
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.itemSlideUpView.removeFromSuperview()
            })
            itemBtnUp = false
        }

    }


    func showCollection() {

    }


    @objc func OnSlideDown(_ sender: UIPanGestureRecognizer) {
            let targetView = sender.view!
            let container = targetView.superview!

            let dy = sender.translation(in: targetView).y
            let newY = max(targetView.frame.minY + dy, 0)
            targetView.frame.origin.y = newY

            let ratioDismiss = targetView.frame.minY > 0.3 * container.frame.height
            let velocityDismiss = sender.velocity(in: targetView).y > 100

            switch sender.state {
            case .ended where ratioDismiss || velocityDismiss:
                self.itemBtnView.cornerRadius = 32
                self.itemBtnToBottom.constant = 96
                self.itemBtnHeight.constant = 64
                UIView.animate(withDuration: 0.2, animations: {
                    targetView.frame.origin.y = container.frame.height
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    targetView.superview!.removeFromSuperview()
                })
                itemBtnUp = false
            case .ended:
                UIView.animate(withDuration: 0.2, animations: {
                    targetView.frame.origin.y = 0
                })
            default:
                break
            }
            sender.setTranslation(.zero, in: targetView)
    }





    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksManager.lowImgs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("selected!")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as? BookCell else { return BookCell() }

        let displayImg = booksManager.lowImgs[indexPath.row]
        let cellID = UUID(uuidString: booksManager.refImgs[indexPath.row].name!)!
        cell.configBookCell(img: displayImg, id: cellID, indexPath: indexPath, delegate: self)
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BookCell
        let TasksVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TasksVC") as! TasksVC
        TasksVC.delegate = self
        TasksVC.modalPresentationStyle = .overFullScreen
        TasksVC.modalTransitionStyle = .crossDissolve

        guard let book = booksManager.getBookForId(cell.cellID!) else { return }

        TasksVC.initData(booksManager: booksManager, book: book)
        self.present(TasksVC, animated: true)
    }


    func onDeleteCell(at indexPath: IndexPath) {
        let cell = booksCollection.cellForItem(at: indexPath) as! BookCell
        guard let book = booksManager.getBookForId(cell.cellID!) else { return }
        booksManager.deleteBook(book: book) { (_) in }
        booksCollection.reloadData()

    }

    func onLongPress(at indexPath: IndexPath) {
        for ip in booksCollection.indexPathsForVisibleItems {
            if ip != indexPath {
                let cell = booksCollection.cellForItem(at: ip) as! BookCell
                cell.configDeselect()
            }
        }
    }




}

