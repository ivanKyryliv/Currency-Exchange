//
//  ExchangeViewController.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    private func setupUI() {
        title = Localized.exchangeNavigationTitle
        navigationController?.view.backgroundColor = Colors.navigationBarColor
        let navigationBar = navigationController?.navigationBar
        navigationBar?.shadowImage = UIImage()
        if #available(iOS 13.0, *) {
            let navigationBarAppearence = UINavigationBarAppearance()
            navigationBarAppearence.shadowColor = .clear
            navigationBar?.scrollEdgeAppearance = navigationBarAppearence
            navigationBar?.standardAppearance = navigationBarAppearence
            navigationBar?.isTranslucent = false
        } else {
            navigationBar?.barTintColor = Colors.navigationBarColor
            navigationBar?.isTranslucent = false
        }
    }
}


//MARK: - RootViewGettable
extension ExchangeViewController: RootViewGettable {
    typealias RootViewType = ExchangeView
}
