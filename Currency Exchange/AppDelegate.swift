//
//  AppDelegate.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static let shared = UIApplication.shared.delegate as? AppDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NavigationService.setup()
        
#if DEV
        print("DEV Scheme")
#elseif PROD
        print("PROD Scheme")
#endif
        return true
    }
}

