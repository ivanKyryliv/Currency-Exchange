//
//  ExchangeViewController.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import UIKit
import MBProgressHUD

class ExchangeViewController: BaseViewController {
    
    //MARK: - Local Constants
    private struct LocalConstants {
        static let maxConversionValueDigits = 7
    }
    
    //MARK: - Properties
    private let conversionResult: CurrencyConversionsProtocol
    private let conversionService: ConversionService
    
    var conversionPercent: Double = 0.7
    var conversionsCount: Int = 1
    var conversionResponce: CurrencyModelProtocol?
    
    var myBalances: [CurrencyModelProtocol] {
        didSet {
            DispatchQueue.main.async {
                self.rootView?.collectionView.reloadData()
            }
        }
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
        rootView?.openKeyboard()
    }
    
    init(conversionResult: CurrencyConversionsProtocol,
         conversionService: ConversionService,
         myBalances: [CurrencyModelProtocol]) {
        self.conversionResult = conversionResult
        self.conversionService = conversionService
        self.myBalances = myBalances
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        rootView?.collectionView.delegate = self
        rootView?.collectionView.dataSource = self
    }
    
    private func currentConversionData() -> CurrencyOperation {
        return CurrencyOperation(myBalances: myBalances,
                                 conversionPercent: conversionPercent,
                                 conversionResponce: conversionResponce,
                                 conversionsCount: conversionsCount,
                                 freeConversionCount: freeConversionCount,
                                 conversionFrom: conversionFrom,
                                 conversionTo: conversionTo)
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
    
    func validateTextFieldDidEndEditingFrom(type: CurrencyType, balance: Double) -> String {
        
        switch type {
        case .JPY:
            let value = Int(balance)
            return "\(value)"
        case .EUR, .USD:
            let formatter = NumberFormatter()
            formatter.allowsFloats = true
            let decimalSeparator = formatter.decimalSeparator ?? "."
            let result = String(balance)
            let split = result.components(separatedBy: decimalSeparator)
            
            switch split.count {
            case 1:
                return "\(result).00"
            case 2:
                if split.last?.count == 0 {
                    return "\(result)00"
                } else if split.last?.count == 1 {
                    return "\(result)0"
                }
            default:
                break
            }
        }
        
        return String(balance)
    }
    
    private func setupActions() {
        
        rootView?.doneToolBarAction = { [unowned self] in
            self.rootView?.closeKeyboard()
        }
        
        rootView?.submitButtonAction = { [unowned self] in
            
            if conversionFrom.currency == conversionTo {
                showAlertWith(message: Localized.pleaseChangeCurrency)
                return
            }
            
            let operation = conversionService.isOperationValid(currentConversionData())
            
            if !operation.isValid, let errorMessage = operation.error {
                return showAlertWith(message: errorMessage)
            }
            
            rootView?.sellCurrencyAmountTextField?.resignFirstResponder()
            
            MBProgressHUD.showAdded(to: view, animated: true)
            conversionResult.currencyConversion(fromAmount: conversionFrom.amount,
                                                fromCurrency: conversionFrom.currency,
                                                toCurrency: conversionTo) {
                [weak self] resultConversion, errorMessage in
                guard let strongSelf = self else { return }
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
                
                if let errorMessage = errorMessage {
                    ErrorService.showError(message: errorMessage)
                } else {
                    if let result = resultConversion {
                        strongSelf.configureConversionResponse(result: result)
                    }
                }
            }
        }
    }
    
    private func configureConversionResponse(result: CurrencyModelProtocol) {
        conversionResponce = CurrencyApiModel(amount: result.amount, currency: result.currency)
        conversionsCount += 1
        rootView?.receiveCurrencyAmountLabel.text = "+ \(result.amount)"
        
        let newBalances = conversionService.newBalancesAfterConversion(currentConversionData())
        myBalances = newBalances
        
        if let message: String = conversionService.showSuccessMessage(currentConversionData()) {
            showAlertWith(message: message, title: Localized.currencyConverted)
        }
    }
}

//MARK: - UITextFieldDelegate
extension ExchangeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        validateCurrencyFrom(textField: textField, range: range, string: string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard conversionFrom.currency != .JPY else { return }
        textField.text = validateTextFieldDidEndEditingFrom(type: conversionFrom.currency, balance: Double(text) ?? 0.00)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if conversionFrom.currency == .JPY {
            textField.keyboardType = .numberPad
        } else {
            textField.keyboardType = .decimalPad
        }
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
            if type == .JPY {
                rootView?.sellCurrencyAmountTextField.text = String(Int(conversionFrom.amount))
            }
        case .receive:
            rootView?.toCurrencyTextField.text = type.rawValue
            rootView?.toCurrencyTextField.resignFirstResponder()
        }
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
        let balance = myBalances[indexPath.row].toString()
        cell.configure(title: balance, maxWidth: collectionView.bounds.width)
        return cell
    }
}

//MARK: - ConversionProtocol
extension ExchangeViewController: ConversionProtocol {
    
    var freeConversionCount: Int {
        return 5
    }
    
    var conversionFrom: CurrencyModelProtocol {
        let ammount: Double = Double(rootView?.sellCurrencyAmountTextField.text ?? "0")  ?? 0
        var currency: CurrencyType = .EUR
        
        if let fromCurrencyTextField = rootView?.fromCurrencyTextField.text,
           let currencyType = CurrencyType(rawValue: fromCurrencyTextField) {
            currency = currencyType
        }
        
        return CurrencyApiModel(amount: ammount, currency: currency)
    }
    
    var conversionTo: CurrencyType {
        if let toCurrencyTextField = rootView?.toCurrencyTextField.text,
           let currency = CurrencyType(rawValue: toCurrencyTextField) {
            return currency
        }
        return .USD
    }
}
