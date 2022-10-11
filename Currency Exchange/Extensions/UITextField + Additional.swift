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
}
