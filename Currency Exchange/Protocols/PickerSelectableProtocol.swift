//
//  PickerSelectable.swift
//  Currency Exchange
//
//  Created by Ivan on 11.10.2022.
//

import UIKit

enum ExchangeType {
    case sell
    case receive
}

protocol PickerSelectable {
    var selectSellTextField: UITextField? { get }
    var selectReceiveTextField: UITextField? { get }
    func configureSellPickerView()
    func configureReceivePickerView()
}

extension PickerSelectable where Self: SelectedCurrencyTypeDelegate {
    
    func configureSellPickerView() {
        guard let currencyPickerView = CurrencyTypePickerView.currencyPickerView else {
            return
        }
        currencyPickerView.selectedCurrencyDelegate = self
        currencyPickerView.exchangeType = .sell
        selectSellTextField?.inputView = currencyPickerView
    }
    
    func configureReceivePickerView() {
        guard let currencyPickerView = CurrencyTypePickerView.currencyPickerView else {
            return
        }
        currencyPickerView.selectedCurrencyDelegate = self
        currencyPickerView.exchangeType = .receive
        selectReceiveTextField?.inputView = currencyPickerView
    }
}
