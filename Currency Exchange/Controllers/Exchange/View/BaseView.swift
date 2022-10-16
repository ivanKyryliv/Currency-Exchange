//
//  BaseView.swift
//  Currency Exchange
//
//  Created by Ivan on 11.10.2022.
//

import UIKit

class BaseView: UIView {
    
    var activeScrollView: UIScrollView?
    
    //MARK: - Keyboard settings
     func addKeyboardNotificationObservers() {
         let notificationCenter = NotificationCenter.default
         notificationCenter.addObserver(self, selector: #selector(setUpKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
         notificationCenter.addObserver(self, selector: #selector(setUpKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
     }
     
     @objc func setUpKeyboard(notification: Notification) {
         let userInfo = notification.userInfo!
         let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
         let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)
         
         if notification.name == UIResponder.keyboardWillHideNotification {
            activeScrollView?.contentInset = .zero
         } else {
             activeScrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height / 2, right: 0)
         }
        activeScrollView?.scrollIndicatorInsets = activeScrollView?.contentInset  ?? .zero
     }
}
