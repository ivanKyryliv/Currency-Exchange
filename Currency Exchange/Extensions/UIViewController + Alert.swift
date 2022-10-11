//
//  UIViewController + Alert.swift
//  Currency Exchange
//
//  Created by Ivan on 11.10.2022.
//

import UIKit

extension UIViewController {
    
    func showAlertWith(message: String?, title: String? = nil, handler: ((UIAlertAction) -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        let okAction = UIAlertAction(title: Localized.ok, style: .cancel, handler: handler)
            alertController.addAction(okAction)
         UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}

