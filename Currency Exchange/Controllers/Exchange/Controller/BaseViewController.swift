//
//  BaseViewController.swift
//  Currency Exchange
//
//  Created by Ivan on 11.10.2022.
//

import UIKit


class BaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.shadowImage = UIImage()
        if #available(iOS 13.0, *) {
            let navigationBarAppearence = UINavigationBarAppearance()
            navigationBarAppearence.backgroundColor = Colors.mainBlueColor
            navigationBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationBarAppearence.shadowColor = .clear
            navigationBar?.scrollEdgeAppearance = navigationBarAppearence
            navigationBar?.standardAppearance = navigationBarAppearence
            navigationBar?.isTranslucent = false
        } else {
            navigationBar?.barTintColor = Colors.mainBlueColor
            navigationBar?.isTranslucent = false
        }
    }
}
