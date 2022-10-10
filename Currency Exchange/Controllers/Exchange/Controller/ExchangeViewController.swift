//
//  ExchangeViewController.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import UIKit

protocol Conversions {
    func currencyConversion(completionHandler: @escaping (_ result: CurrencyConverterApiModel?,
                                                          _ errorMessage: String?) -> Void)
}

struct ConversionResult: Conversions {
    func currencyConversion(completionHandler: @escaping (CurrencyConverterApiModel?, String?) -> Void) {
        
        let testData = CurrencyRequest(fromAmount: 340.51,
                                       fromCurrency: CurrencyType.EUR,
                                       toCurrency: CurrencyType.JPY)
        
        let fetchConversions = FetchConversions(currencyRequest: testData)
        
        NetworkService.shared.performApiRequest(fetchConversions) {
            (result: Result<ApiResponse<CurrencyConverterApiModel>>) in
            switch result {
            case .success(let response):
                completionHandler(response.entity, nil)
            case let .failure(error):
                completionHandler(nil, error.errorMessage)
            }
        }
    }
}

class ExchangeViewController: UIViewController {
    
    //MARK: - Properties
    private let conversionResult = ConversionResult()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        testConversion()
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
    
    private func testConversion() {
        conversionResult.currencyConversion { [weak self] resultData, errorMessage in
            
            guard let strongSelf = self else { return }
            
            if let errorMessage = errorMessage {
                ErrorService.showError(message: errorMessage)
            } else {
                if let result = resultData {
                    strongSelf.rootView?.testLabel.text = " 340.51 EUR = \(result.amount) \(result.currency.rawValue)"
                }
            }
        }
    }
}


//MARK: - RootViewGettable
extension ExchangeViewController: RootViewGettable {
    typealias RootViewType = ExchangeView
}
