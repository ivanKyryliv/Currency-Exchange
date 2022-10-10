//
//  ErrorService.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import UIKit

class ErrorService {
    
    static func showError(title:String? = nil, message:String?, handler: ((UIAlertAction) -> ())? = nil) {
        
        let alert = UIAlertController(title: title ?? Localized.error,
                                      message: message ?? Localized.unknownMessage,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: Localized.ok, style: .cancel, handler: handler)
        alert.addAction(okAction)
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}

