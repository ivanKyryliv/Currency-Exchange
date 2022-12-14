//
//  UIApplicaation + TopViewController.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import UIKit

extension UIApplication {
    
    class func topViewController(baseViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = baseViewController as? UINavigationController {
            return topViewController(baseViewController: navigationController.visibleViewController)
        }
        
        if let tabBarViewController = baseViewController as? UITabBarController {
            
            let moreNavigationController = tabBarViewController.moreNavigationController
            
            if let topVC = moreNavigationController.topViewController, topVC.view.window != nil {
                return topViewController(baseViewController: topVC)
            } else if let selectedViewController = tabBarViewController.selectedViewController {
                return topViewController(baseViewController: selectedViewController)
            }
        }
        
        if let splitViewController = baseViewController as? UISplitViewController, splitViewController.viewControllers.count == 1 {
            return topViewController(baseViewController: splitViewController.viewControllers[0])
        }
        
        if let presentedViewController = baseViewController?.presentedViewController {
            return topViewController(baseViewController: presentedViewController)
        }
        
        return baseViewController
    }
}
