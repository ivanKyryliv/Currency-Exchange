//
//  ExchangeView.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import UIKit

class ExchangeView: BaseView {
    
    //MARK: - Properties
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var myBalancesLabel: UILabel!
    @IBOutlet private weak var currencyExchangeLabel: UILabel!
    @IBOutlet private weak var sellLabel: UILabel!
    @IBOutlet private weak var receiveLabel: UILabel!
    
    @IBOutlet weak var sellCurrencyAmountTextField: UITextField!
    
    @IBOutlet weak var fromCurrencyTextField: UITextField! {
        didSet {
            fromCurrencyTextField.setIcon(UIImage(named: "path")!)
        }
    }

    @IBOutlet weak var toCurrencyTextField: UITextField! {
        didSet {
            toCurrencyTextField.setIcon(UIImage(named: "path")!)
        }
    }
    
    @IBOutlet weak var receiveCurrencyAmountLabel: UILabel!
    
    @IBOutlet private weak var sellCircleView: UIView!
    @IBOutlet private weak var receiveCircleView: UIView!
    
    @IBOutlet weak var receiveSeparatorView: UIView!
    @IBOutlet weak var sellSeparatorView: UIView!
    
    @IBOutlet private weak var upImageView: UIImageView!
    @IBOutlet private weak var downImageView: UIImageView!
    
    @IBOutlet private weak var submitButton: UIButton!
    
    var submitButtonAction: (()->())?
    
    override var activeScrollView: UIScrollView? {
        set {
            super.activeScrollView = scrollView
        }
        get {
            return self.scrollView
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        localizeUI()
        configureUI()
    }
    
    private func localizeUI() {
        myBalancesLabel.text = Localized.myBalances.uppercased()
        currencyExchangeLabel.text = Localized.currencyExchange.uppercased()
        
        sellLabel.text = Localized.sell
        receiveLabel.text = Localized.receive
        
        submitButton.setTitle(Localized.submit.uppercased(), for: .normal)
        submitButton.backgroundColor = Colors.mainBlueColor
    }
    
    private func configureUI() {
        receiveCurrencyAmountLabel.text = nil
        sellCircleView.setupCornerRadius(backgroundColor: Colors.mainRedColor)
        receiveCircleView.setupCornerRadius(backgroundColor: Colors.mainGreenColor)
        
        upImageView?.image = upImageView?.image?.withRenderingMode(.alwaysTemplate)
        upImageView?.tintColor = Colors.mainWhiteColor
        
        downImageView?.image = downImageView?.image?.withRenderingMode(.alwaysTemplate)
        downImageView?.tintColor = Colors.mainWhiteColor
        
        receiveCurrencyAmountLabel.textColor = Colors.lightGreenColor
        sellCurrencyAmountTextField.keyboardType = .decimalPad
        sellCurrencyAmountTextField.borderStyle = .none
        sellCurrencyAmountTextField.textAlignment = .right
        
        sellSeparatorView.backgroundColor = Colors.lightGrayColor
        receiveSeparatorView.backgroundColor = Colors.lightGrayColor
        fromCurrencyTextField.text = CurrencyType.EUR.rawValue
        toCurrencyTextField.text = CurrencyType.USD.rawValue
    }
    
    //MARK: - IBActions
    @IBAction private func submitButtonAction(_ sender: Any) {
        submitButtonAction?()
    }
}

