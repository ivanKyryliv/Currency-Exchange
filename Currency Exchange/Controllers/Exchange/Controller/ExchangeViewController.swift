//
//  ExchangeViewController.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import UIKit
import MBProgressHUD

protocol CurrencySelectable {
    var fromAmount: Double { get }
    var fromCurrency: CurrencyType { get }
    var toCurrency: CurrencyType { get }
    var defaultMyBalances: [CurrencyType: Double] { get }
}

protocol Conversions {
    func currencyConversion(fromAmount: Double, fromCurrency: String, toCurrency: String,
                            completionHandler: @escaping (_ result: CurrencyConverterApiModel?, _ errorMessage: String?) -> Void)
}

struct ConversionResult: Conversions {
    func currencyConversion(fromAmount: Double, fromCurrency: String, toCurrency: String,
                            completionHandler: @escaping (CurrencyConverterApiModel?, String?) -> Void) {
        
        let testData = CurrencyRequest(fromAmount: fromAmount,
                                       fromCurrency: fromCurrency,
                                       toCurrency: toCurrency)
        
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
    private let maxConversionValueDigits = 7
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        rootView?.sellCurrencyAmountTextField.delegate = self
        rootView?.addKeyboardNotificationObservers()
        configureSellPickerView()
        configureReceivePickerView()
        rootView?.sellCurrencyAmountTextField.text = "100"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
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
        
        if string.isEmpty { return true }
        
        let currentText = textField.text ?? ""

        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.first == "0" {
            return false
        }
        
        return updatedText.isValidDouble(maxDecimalPlaces: 2, maxDigits: maxConversionValueDigits)
    }
    
    private func setupActions() {
        rootView?.submitButtonAction = { [unowned self] in
            
            if fromAmount == 0 {
                return showAlertWith(message: Localized.pleaseEnterValue)
            }
            
            rootView?.sellCurrencyAmountTextField?.resignFirstResponder()
            MBProgressHUD.showAdded(to: view, animated: true)
            conversionResult.currencyConversion(fromAmount: fromAmount,
                                                fromCurrency: fromCurrency.rawValue,
                                                toCurrency: toCurrency.rawValue) {
                [weak self] resultConverion, errorMessage in
                guard let strongSelf = self else { return }
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
                
                if let errorMessage = errorMessage {
                    ErrorService.showError(message: errorMessage)
                } else {
                    if let result = resultConverion {
                        strongSelf.rootView?.receiveCurrencyAmountLabel.text = "+ \(result.amount)"
                    }
                }
            }
            print("submit button action")
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

//MARK: - PickerSelectable
extension ExchangeViewController: PickerSelectable {
    var selectSellTextField: UITextField? {
        rootView?.fromCurrencyTextField
    }
    
    var selectReceiveTextField: UITextField? {
        rootView?.toCurrencyTextField
    }
}

//MARK: - SelectedCurrencyTypeDelegate
extension ExchangeViewController: SelectedCurrencyTypeDelegate {
    
    func didSelect(type: CurrencyType, exchangeType: ExchangeType) {
        rootView?.receiveCurrencyAmountLabel.text = nil
        switch exchangeType {
        case .sell:
            rootView?.fromCurrencyTextField.text = type.rawValue
            rootView?.fromCurrencyTextField.resignFirstResponder()
        case .receive:
            rootView?.toCurrencyTextField.text = type.rawValue
            rootView?.toCurrencyTextField.resignFirstResponder()
        }
        print("didselect picker")
    }
}

//MARK: - SelectedCurrencyTypeDelegate
extension ExchangeViewController: CurrencySelectable {
    var defaultMyBalances: [CurrencyType: Double] {
        //default 1000.00 EUR, 0.00 USD, 0 JPY.
        return [CurrencyType.EUR: 1000.00,
                CurrencyType.USD: 0.00,
                CurrencyType.JPY: 0]
    }
    
    var fromAmount: Double {
        guard let ammountString = rootView?.sellCurrencyAmountTextField.text else { return 0.0 }
        return Double( ammountString) ?? 0.0
    }
    
    var fromCurrency: CurrencyType {
        if let fromCurrencyTextField = rootView?.fromCurrencyTextField.text,
           let currency = CurrencyType(rawValue: fromCurrencyTextField) {
            return currency
        }
        return .EUR
    }
    
    var toCurrency: CurrencyType {
        if let toCurrencyTextField = rootView?.toCurrencyTextField.text,
           let currency = CurrencyType(rawValue: toCurrencyTextField) {
            return currency
        }
        return .USD
    }
}
