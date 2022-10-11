//
//  CurrencyTypePickerView.swift
//  Currency Exchange
//
//  Created by Ivan on 11.10.2022.
//

import UIKit

protocol SelectedCurrencyTypeDelegate: AnyObject {
    func didSelect(type: CurrencyType, exchangeType: ExchangeType)
}

class CurrencyTypePickerView: UIView {

    //MARK: - Properties
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var pickerView: UIPickerView!
   
    var exchangeType: ExchangeType = .sell
    weak var selectedCurrencyDelegate: SelectedCurrencyTypeDelegate?
    private var currencyType: [CurrencyType] = [.USD, .EUR, .JPY]
    
    //MARK: - Properties
    static var currencyPickerView: CurrencyTypePickerView? {
        guard let pickerView = Bundle.main.loadNibNamed("CurrencyTypePickerView", owner: self, options: nil)?.first as? CurrencyTypePickerView else {
            return nil
        }
        return pickerView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        assingDelegates()
        doneButton.setTitle(Localized.done, for: .normal)
    }
    
    private func assingDelegates() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction private func doneButtonAction(_ sender: Any) {
        selectedCurrencyDelegate?.didSelect(type: currencyType[pickerView.selectedRow(inComponent: 0)], exchangeType: exchangeType)
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension CurrencyTypePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyType[row].rawValue
    }
}

