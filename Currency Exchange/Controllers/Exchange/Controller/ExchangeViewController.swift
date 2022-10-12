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
    var myBalances: [CurrencyType: Double] { get set }
    var currencyConversionPercent: Double { get set }
    var currencyConversionsCount: Int { get set }
    var freeConversionCount: Int { get }
}

protocol Conversions {
    func currencyConversion(fromAmount: Double,
                            fromCurrency: String,
                            toCurrency: String,
                            completionHandler: @escaping (_ result: CurrencyConverterApiModel?, _ errorMessage: String?) -> Void)
}

struct ConversionResult: Conversions {
    func currencyConversion(fromAmount: Double,
                            fromCurrency: String,
                            toCurrency: String,
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

class ExchangeViewController: BaseViewController {
    
    //MARK: - Local Constants
    private struct LocalConstants {
        static let defaulMyBalances: [CurrencyType: Double] = [CurrencyType.EUR: 1000.00,
                                                               CurrencyType.USD: 0.00,
                                                               CurrencyType.JPY: 0]
        static let maxConversionValueDigits = 7
    }
    
    //MARK: - Properties
    private let conversionResult = ConversionResult()
    
    var myBalances: [CurrencyType : Double] = LocalConstants.defaulMyBalances
    var currencyConversionPercent = 0.7
    var currencyConversionsCount = 1
    
    private var getConversionCommission: Double {
        if currencyConversionsCount > freeConversionCount {
            return (fromAmount / 100 * currencyConversionPercent).rounded(digits: 2)
        }
        return 0.0
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localized.exchangeNavigationTitle
        setupActions()
        configureCollectionView()
        rootView?.sellCurrencyAmountTextField.delegate = self
        rootView?.addKeyboardNotificationObservers()
        configureSellPickerView()
        configureReceivePickerView()
        rootView?.sellCurrencyAmountTextField.text = "100"
    }
    
    private func configureCollectionView() {
        rootView?.collectionView.delegate = self
        rootView?.collectionView.dataSource = self
    }
    
    private func configureMyBalanceFrom(type: CurrencyType) -> String {
        if let balance = myBalances[type] {
            
            if type == .JPY {
                return "\(Int(balance)) \(type.rawValue)"
            }
            
            return "\(balance) \(type.rawValue)"
        }
        
        if type == .JPY {
            return "0 \(type.rawValue)"
        }
        
        return "0.00 \(type.rawValue)"
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
        
        return updatedText.isValidDouble(maxDecimalPlaces: 2, maxDigits: LocalConstants.maxConversionValueDigits)
    }
    
    private func setupActions() {
        rootView?.submitButtonAction = { [unowned self] in
            
            if fromAmount == 0 {
                return showAlertWith(message: Localized.pleaseEnterValue)
            }
            
            if let fromCurrencyMyBalance = myBalances[fromCurrency],
               fromCurrencyMyBalance - fromAmount - getConversionCommission < 0 {
                return showAlertWith(message: Localized.notEnoughMoneyConversion)
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
                        
                        var message = "You have converted \(strongSelf.fromAmount) \(strongSelf.fromCurrency.rawValue) to \(result.amount) \(strongSelf.toCurrency.rawValue) "
                        
                        if strongSelf.getConversionCommission > 0 {
                            message.append("Commission Fee - \(strongSelf.getConversionCommission) \(strongSelf.fromCurrency)")
                        }
                        
                        strongSelf.showAlertWith(message: message,
                                                 title: Localized.currencyConverted)
                        { _ in
                            strongSelf.calculateMyBalances(fromAmount: strongSelf.fromAmount,
                                                           fromCurrency: strongSelf.fromCurrency,
                                                           toCurrency: strongSelf.toCurrency,
                                                           resultAmmount: result.amount,
                                                           commissionFee: strongSelf.getConversionCommission)
                        }
                    }
                }
            }
        }
    }
    
    private func calculateMyBalances(fromAmount: Double,
                                     fromCurrency: CurrencyType,
                                     toCurrency: CurrencyType,
                                     resultAmmount: String,
                                     commissionFee: Double?) {
        currencyConversionsCount += 1
        
        rootView?.receiveCurrencyAmountLabel.text = "+ \(resultAmmount)"
        
        if let fromCurrencyMyBalance = myBalances[fromCurrency] {
            myBalances[fromCurrency] = (fromCurrencyMyBalance - fromAmount - getConversionCommission).rounded(digits: 2)
        }
        
        if let toCurrencyMyBalance = myBalances[toCurrency], let ammount = Double(resultAmmount) {
            myBalances[toCurrency] = (toCurrencyMyBalance + ammount).rounded(digits: 2)
        }
        
        DispatchQueue.main.async {
            self.rootView?.collectionView.reloadData()
        }
    }
}

//MARK: - UITextFieldDelegate
extension ExchangeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        validateCurrencyFrom(textField: textField, range: range, string: string)
    }
    
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
    }
}

//MARK: - SelectedCurrencyTypeDelegate
extension ExchangeViewController: CurrencySelectable {
    var freeConversionCount: Int {
        return 5
    }
    
    var defaulMyBalances: [CurrencyType : Double] {
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

//MARK: - SelectedCurrencyTypeDelegate
extension ExchangeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return myBalances.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCellWithClass(BalanceCollectionViewCell.self, path: indexPath)
        
        var balanceString: String = "0.00"
        switch indexPath.row {
        case 0:
            balanceString = configureMyBalanceFrom(type: CurrencyType.EUR)
        case 1:
            balanceString = configureMyBalanceFrom(type: CurrencyType.USD)
        case 2:
            balanceString = configureMyBalanceFrom(type: CurrencyType.JPY)
        default:
            break
        }
        
        cell.configure(title: balanceString, maxWidth: collectionView.bounds.width)
        return cell
    }
}
