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
    private let maxConversionValueDigits = 10
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        rootView?.sellCurrencyAmountTextField.text = "100"
        rootView?.sellCurrencyAmountTextField.delegate = self
        rootView?.addKeyboardNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        testConversion()
    }
    
    private func setupUI() {
        title = Localized.exchangeNavigationTitle
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
    
    private func validateCurrencyFrom(textField: UITextField, range: NSRange, string: String) -> Bool {
        if textField.text?.count == 0 && string == "0" {
            return false
        }
        
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.first == "0" {
            return false
        }
        
        return updatedText.count <= maxConversionValueDigits
    }
    
    private func setupActions() {
        rootView?.submitButtonAction = { [unowned self] in
            
            rootView?.sellCurrencyAmountTextField?.resignFirstResponder()
            print("submit button action")
        }
        
        rootView?.sellChangeCurrencyButtonAction = { [unowned self] in
            print("sell change currency buttonAction ")
        }
    }
    
    
    private func testConversion() {
        conversionResult.currencyConversion { [weak self] resultData, errorMessage in
            
            guard let strongSelf = self else { return }
            
            if let errorMessage = errorMessage {
                ErrorService.showError(message: errorMessage)
            } else {
                if let result = resultData {
                    //                    strongSelf.rootView?.testLabel.text = " 340.51 EUR = \(result.amount) \(result.currency.rawValue)"
                    //                    strongSelf.rootView?.testLabel.text = countryFlag(countryCode: "EU")
                    
                }
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension ExchangeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        validateCurrencyFrom(textField: textField, range: range, string: string)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) { }
    
    func textFieldDidEndEditing(_ textField: UITextField) { }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

//MARK: - RootViewGettable
extension ExchangeViewController: RootViewGettable {
    typealias RootViewType = ExchangeView
}
