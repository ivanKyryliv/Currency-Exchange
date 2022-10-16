//
//  CurrencyOperation.swift
//  Currency Exchange
//
//  Created by Ivan on 16.10.2022.
//

import Foundation

class CurrencyOperation: CurrencyOperationProtocol {
    var myBalances: [CurrencyModelProtocol]
    var conversionPercent: Double
    var conversionsCount: Int
    var freeConversionCount: Int
    var conversionFrom: CurrencyModelProtocol
    var conversionTo: CurrencyType
    var conversionResponce: CurrencyModelProtocol?
    
    var calculateCommission: CurrencyModelProtocol {
        if conversionsCount > freeConversionCount, conversionFrom.amount > 0  {
            return CurrencyApiModel(amount: (conversionFrom.amount / 100 * conversionPercent),
                                    currency: conversionFrom.currency)
        }
        return CurrencyApiModel(amount: 0, currency: conversionFrom.currency)
    }
    
    
    init(myBalances: [CurrencyModelProtocol],
         conversionPercent: Double,
         conversionResponce: CurrencyModelProtocol?,
         conversionsCount: Int,
         freeConversionCount: Int,
         conversionFrom: CurrencyModelProtocol,
         conversionTo: CurrencyType) {
        self.myBalances = myBalances
        self.conversionPercent = conversionPercent
        self.conversionResponce = conversionResponce
        self.conversionsCount = conversionsCount
        self.freeConversionCount = freeConversionCount
        self.conversionFrom = conversionFrom
        self.conversionTo = conversionTo
    }
    
    func calculateMyNewBalanceAfterConversion() -> [CurrencyModelProtocol] {
        
        if let fromIndex = myBalances.firstIndex(where: {$0.currency == conversionFrom.currency}) {
            myBalances[fromIndex].amount = decrementConversion()
        }
        
        if let fromIndex = myBalances.firstIndex(where: {$0.currency == conversionTo}) {
            myBalances[fromIndex].amount = incrementConversion()
        }
        
        return myBalances
    }
    
    func decrementConversion() -> Double {
        guard let myBalanceFromCurrency = myBalances.filter({$0.currency == conversionFrom.currency}).first?.amount else {
            return 0
        }
        
        return myBalanceFromCurrency - conversionFrom.amount - calculateCommission.amount
    }
    
    func incrementConversion() -> Double {
        guard let myBalanceToCurrency = myBalances.filter({$0.currency == conversionTo}).first?.amount else {
            return 0
        }
        let conversionResponce = conversionResponce?.amount ?? 0.0
        return myBalanceToCurrency + conversionResponce
    }
    
    func isOperationValid() -> (isValid: Bool, error: String?) {
        if conversionFrom.amount == 0 {
            return (isValid: false, error: Localized.pleaseEnterValue)
        }
        
        if decrementConversion() < 0 {
            return (isValid: false, error: Localized.notEnoughMoneyConversion)
        }
        
        return (isValid: true, error: nil)
    }
    
    func successMessage() -> String? {
        guard let conversionResponce = conversionResponce else { return nil }
        var message = String.localizedStringWithFormat(Localized.youHaveConverted, conversionFrom.toString(), conversionResponce.toString())
        
        if calculateCommission.amount > 0 {
            
            var commission = " \(Localized.commissionFee) \(calculateCommission.toString())."
            
            if conversionFrom.currency == .JPY && calculateCommission.amount < 1 {
                commission = " \(Localized.commissionFee) \(calculateCommission.amount.stringValue2f()) \(calculateCommission.currency)."
            }
            
            message.append(commission)
        }
        
        return message
    }
}

