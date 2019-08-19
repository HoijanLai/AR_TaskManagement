//
//  KeyboardAdaptive.swift
//
//  Created by Hoijan Lai on 2019/3/12.
//  Copyright © 2019 Hoijan Lai. All rights reserved.
//

import UIKit

class ExtScrollView: UIScrollView {
    
    override func awakeFromNib() {
        // listen to keyboard
        NotificationCenter.default.addObserver(
            self, selector:
            #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    // handle scrollview inset while keyboard appears
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 50) * (show ? 1 : -1)
        self.contentInset.bottom = adjustmentHeight
        self.scrollIndicatorInsets.bottom = adjustmentHeight
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
}
