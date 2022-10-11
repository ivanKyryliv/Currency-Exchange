//
//  UIView + Additional.swift
//  Currency Exchange
//
//  Created by Ivan on 11.10.2022.
//

import UIKit

extension UIView {
    func setupCornerRadius(backgroundColor: UIColor? = nil) {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        if let color = backgroundColor {
            self.backgroundColor = color
        }
    }
    
    func setupBorderFrom(cornerRadius: CGFloat? = nil, borderWidth: CGFloat, color: UIColor?) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius ?? self.frame.height / 2
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color?.cgColor ?? UIColor.black.cgColor
    }
}
