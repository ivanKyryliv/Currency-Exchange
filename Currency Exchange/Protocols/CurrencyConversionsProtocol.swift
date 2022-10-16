//
//  ConversionsProtocol.swift
//  Currency Exchange
//
//  Created by Ivan on 16.10.2022.
//

import Foundation

protocol CurrencyConversionsProtocol {
    func currencyConversion(fromAmount: Double,
                            fromCurrency: CurrencyType,
                            toCurrency: CurrencyType,
                            completionHandler: @escaping (_ result: CurrencyModelProtocol?, _ errorMessage: String?) -> Void)
}
