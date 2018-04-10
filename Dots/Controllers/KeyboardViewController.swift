//
//  KeyboardViewController.swift
//  Flip
//
//  Created by Sasha on 2/20/17.
//  Copyright © 2017 Qbits. All rights reserved.
//

import UIKit

class KeyboardViewController: BaseViewController {
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    var botConstant = CGFloat(0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(KeyboardViewController.keyboardWillShowForResizing),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(KeyboardViewController.keyboardWillHideForResizing),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK:- Notifications
extension KeyboardViewController {
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: TimeInterval(notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double), animations: {
                if let tabBarController = self.tabBarController {
                    self.bottomConstraint.constant = keyboardSize.height - tabBarController.tabBar.frame.size.height
                } else {
                    self.bottomConstraint.constant = keyboardSize.height
                }
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        UIView.animate(withDuration: TimeInterval(notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double), animations: {
            self.bottomConstraint.constant = self.botConstant
            self.view.layoutIfNeeded()
        })
    }
}
