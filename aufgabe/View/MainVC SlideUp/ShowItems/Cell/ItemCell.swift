//
//  ItemCell.swift
//  aufgabe
//
//  Created by Hoijan Lai on 2019/8/12.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit


enum gestureState {
    case pan, tap, both
}

protocol ItemCellDelegate: class {
    func cellActionWillShow()
    func onViewCellDetail(cellID: UUID, iP: IndexPath)
    func onDeleteCell()
}

class ItemCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainView: ExtView!


    weak var delegate: ItemCellDelegate?
    var cellID: UUID!
    var iP: IndexPath!


    var actionView: UIView?


    func configCell(id: UUID, at indexPath: IndexPath) {
        guard let item = itemsManager.getItemForId(id) else { return }
        cellID = id
        iP = indexPath
        titleLabel.text = item.name
        imageView.image = itemsManager.lowImgs[iP.row]


        // action views
        rewindActionView(animated: false)
        handleGR(state: .pan)


    }


    func rewindActionView(animated: Bool = true) {
        if actionView != nil {
            UIView.animate(withDuration: animated ? 0.1 : 0.0, animations: {
                self.mainView.frame.origin.y = 0
            }) { (_) in
                self.actionView?.removeFromSuperview()
                self.actionView = nil

            }
        }
    }

}


/*
 Actions
 */
extension ItemCell {
    @objc
    func detailTapped(_ sender: UIButton) {
        delegate?.onViewCellDetail(cellID: cellID, iP: iP)
    }


    @objc
    func deleteTapped(_ sender: UIButton) {
        if let item = itemsManager.getItemForId(cellID) {
            itemsManager.deleteItem(item: item, self.iP)
        }
    }


    private func handleGR(state: gestureState) {
        for gr in contentView.gestureRecognizers ?? [] {
            contentView.removeGestureRecognizer(gr)
        }
        switch state {
        case .pan:
            contentView.addGestureRecognizer(panGR())

        case .tap:
            contentView.addGestureRecognizer(tapGR())

        case .both:
            contentView.addGestureRecognizer(panGR())
            contentView.addGestureRecognizer(tapGR())
        }

    }

}























/*
Implementations
*/


extension ItemCell {

    private func tapGR() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        return tap
    }


    private func panGR() -> UIGestureRecognizer {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        return pan
    }





    @objc
    func onPan(_ sender: UIPanGestureRecognizer) {

        let dy = sender.translation(in: contentView).y
        let newY = min(max(-0.4*frame.height, mainView.frame.origin.y + dy), 0)


        let rPass = sender.velocity(in: contentView).y > 100
        let yPass = mainView.frame.maxY < frame.height*0.7



        switch sender.state {
        case .began:
            if actionView == nil {
                delegate?.cellActionWillShow()
                actionView = createActionsView()
                mainView.superview!.insertSubview(actionView!, belowSubview: mainView)

            }

        case .changed:
            self.mainView.frame.origin.y = newY


        case .ended where (yPass || rPass) && dy < 0:
            UIView.animate(withDuration: 0.2, animations: {
                self.mainView.frame.origin.y =  -self.frame.height*0.3
            }) { (_) in
                self.handleGR(state: .both)
            }

        case .ended where !yPass || (rPass && dy >= 0):
            rewindActionView()

        default:
            break
        }

    }

    @objc
    func onTap(_ sender: UITapGestureRecognizer) {
        rewindActionView()
        handleGR(state: .pan)
        // activate: * when actions were shown
        //           * the cell get deselected
    }







    private func createActionsView() -> UIView {

        let deleteBtn = UIButton()
        deleteBtn.setImage(#imageLiteral(resourceName: "cancel_red"), for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)
        deleteBtn.addConstraint(NSLayoutConstraint(item: deleteBtn,
                                                   attribute:.height,
                                                   relatedBy: .equal,
                                                   toItem: deleteBtn,
                                                   attribute: .width,
                                                   multiplier: 1,
                                                   constant: 0))

        let viewBtn = UIButton()
        viewBtn.setImage(#imageLiteral(resourceName: "item_light"), for: .normal)
        viewBtn.addTarget(self, action: #selector(detailTapped(_:)), for: .touchUpInside)
        viewBtn.addConstraint(NSLayoutConstraint(item: viewBtn,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: viewBtn,
                                                 attribute: .width,
                                                 multiplier: 1,
                                                 constant: 0))


        let btnStack = UIStackView(arrangedSubviews: [deleteBtn, viewBtn])


        btnStack.axis = .horizontal
        btnStack.distribution = .equalCentering


        btnStack.frame = CGRect(origin: CGPoint(x: 15, y: frame.height*0.8), size: CGSize(width: frame.width - 30, height: frame.height*0.2))


        return btnStack
    }
}




extension ItemCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        guard let panA = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        guard let panB = otherGestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }

        let dyA = panA.translation(in: contentView).y
        let dyB = panB.translation(in: panB.view).y
        let dxB = panB.translation(in: panB.view).x
        return dyA * dyB < 0 || abs(dxB) > abs(dyB)


    }
}


