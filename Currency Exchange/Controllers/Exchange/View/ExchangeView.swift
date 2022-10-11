//
//  ExchangeView.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import UIKit

class ExchangeView: UIView {
    
    //MARK: - Properties
    @IBOutlet private weak var myBalancesLabel: UILabel!
    @IBOutlet private weak var currencyExchangeLabel: UILabel!
    @IBOutlet private weak var sellLabel: UILabel!
    @IBOutlet private weak var receiveLabel: UILabel!
    @IBOutlet private weak var sellCurrencyAmountTextField: UITextField!
    @IBOutlet private weak var sellCurencyTypeLabel: UILabel!
    @IBOutlet private weak var receiveCurrencyAmountLabel: UILabel!
    @IBOutlet private weak var receiveCurrencyTypeLabel: UILabel!
    
    @IBOutlet private weak var sellCircleView: UIView!
    @IBOutlet private weak var receiveCircleView: UIView!
    
    @IBOutlet private weak var submitButton: UIButton!
    
    var submitButtonAction: (()->())?
    
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        localizeUI()
    }
    
    private func localizeUI() {
        myBalancesLabel.text = Localized.myBalances.uppercased()
        currencyExchangeLabel.text = Localized.currencyExchange.uppercased()
        
        sellLabel.text = Localized.sell
        receiveLabel.text = Localized.receive
        
        submitButton.setTitle(Localized.submit.uppercased(), for: .normal)
        submitButton.backgroundColor = Colors.navigationBarColor
    }
    
    //MARK: - IBActions
    @IBAction private func submitButtonAction(_ sender: Any) {
        submitButtonAction?()
    }
}
