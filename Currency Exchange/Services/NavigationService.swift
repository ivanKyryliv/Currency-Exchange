//
//  NavigationService.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import UIKit

class NavigationService {
    
    static func setup() {
        AppDelegate.shared?.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationVC = UINavigationController(rootViewController: ExchangeViewController())
        AppDelegate.shared?.window?.rootViewController = navigationVC
        AppDelegate.shared?.window?.makeKeyAndVisible()
    }
}
