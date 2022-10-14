//
//  UITextField + Additional.swift
//  Currency Exchange
//
//  Created by Ivan on 11.10.2022.
//

import UIKit

extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 0, width: 15, height: 15))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 10, y: self.frame.height/2, width: 15, height: 15))
        iconContainerView.addSubview(iconView)
        rightView = iconContainerView
        rightViewMode = .always
    }
    
    func setupToolBarFor(action: Selector, and buttonTitle: String, target: Any? = nil) {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 32))
        toolBar.barStyle = .default
        let button = UIBarButtonItem(title: buttonTitle,
                                         style: .done, target: target, action: action)
        button.tintColor = .black
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [space, button]
        toolBar.sizeToFit()
        inputAccessoryView = toolBar
    }
}
