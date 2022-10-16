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
        let defaultMyBalances = [CurrencyApiModel(amount: 1000, currency: CurrencyType.EUR),
                                 CurrencyApiModel(amount: 0, currency: CurrencyType.USD),
                                 CurrencyApiModel(amount: 0, currency: CurrencyType.JPY)]
        
        let exchangeViewController = ExchangeViewController(conversionResult: ConversionResult(),
                                                            conversionService: ConversionService(),
                                                            myBalances: defaultMyBalances)
        
        let navigationVC = UINavigationController(rootViewController: exchangeViewController)
        AppDelegate.shared?.window?.rootViewController = navigationVC
        AppDelegate.shared?.window?.makeKeyAndVisible()
    }
}
