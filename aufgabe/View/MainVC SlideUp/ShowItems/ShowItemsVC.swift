//
//  showItemsView.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/8/12.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit





class ShowItemsVC: UIViewController {

    @IBOutlet weak var itemCollection: UICollectionView!
    @IBOutlet weak var addHint: UIStackView!

    
    override func viewDidLoad() {
        itemCollection.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        itemCollection.register(UINib(nibName: "ItemFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ItemFooter")
        itemCollection.delegate = self
        itemCollection.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1
        }
        itemCollection.isHidden = itemsManager.count <= 0
        addHint.isHidden = itemsManager.count > 0
    }

    @IBAction func addBtnTapped(_ sender: Any) {
        self.presentAddVC()
    }




    private func presentAddVC() {
        guard let nav = navigationController else { return }
        UIView.animate(withDuration: 0.1, animations: {
            nav.viewControllers.last?.view.alpha = 0
        }) { (_) in
                nav.popViewController(animated: false)
                nav.pushViewController(AddItemVC(nibName: "AddItemView", bundle: nil), animated: false)
        }
    }


}

extension ShowItemsVC: UICollectionViewDelegate, UICollectionViewDataSource, ItemFooterDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemCollection.isHidden = itemsManager.count <= 0
        addHint.isHidden = itemsManager.count > 0
        return itemsManager.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? ItemCell else { return ItemCell() }
        let cellID = UUID(uuidString: itemsManager.refImgs[indexPath.row].name!)! // TODO: check duplicate
        cell.delegate = self
        cell.configCell(id: cellID, at: indexPath)
        return cell

    }


    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ItemFooter", for: indexPath) as? ItemFooter else { return UICollectionReusableView() }
        footerView.delegate = self
        return footerView
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCell else { return }
        cellWillEdit(with: cell.cellID)
    }


    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCell else { return }
        cell.rewindActionView()
    }


    func addItem() {
        self.presentAddVC()
    }

}


extension ShowItemsVC: ItemCellDelegate {
    
    
    func cellActionWillShow() {
        for c in itemCollection.visibleCells {
            guard let cell = c as? ItemCell else { return }
            cell.rewindActionView()
        }
    }

    func onDeleteCell() {
        itemCollection.reloadData()
    }


    func onViewCellDetail(cellID: UUID, iP: IndexPath) {
        guard let mainScreen = UIApplication.shared.keyWindow?.rootViewController as? MainVC else { return }

        let detailVC = ItemDetailVC(nibName: "ItemDetailVC", bundle: nil)
        detailVC.configWithItemId(itemId: cellID, at: iP)

        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.modalTransitionStyle = .crossDissolve


        if let nav = navigationController as? SlideUpNavVC {
            nav.dismiss(animated: true, completion: nil)
        }
        
        mainScreen.present(detailVC, animated: true)
    }

}






/*
 detailed implementations
 */
extension ShowItemsVC {
    private func cellWillEdit(with id: UUID) {
        guard let item = itemsManager.getItemForId(id) else { return }
        guard let mainScreen = UIApplication.shared.keyWindow?.rootViewController as? MainVC else { return }

        let taskVC = TaskVC(nibName: "TaskView", bundle: nil)
        taskVC.setItem(item)
        taskVC.delegate = mainScreen
        
        let taskScreen = TaskNavVC(rootViewController: taskVC)
        

        taskScreen.modalPresentationStyle = .overCurrentContext
        taskScreen.modalTransitionStyle = .crossDissolve

        // TODO : dismiss slideup & toggle dark mask
        if let nav = navigationController as? SlideUpNavVC {
            nav.dismiss(animated: true, completion: nil)
        }

        mainScreen.present(taskScreen, animated: true)
    }
}


