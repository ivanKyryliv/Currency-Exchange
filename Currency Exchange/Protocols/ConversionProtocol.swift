//
//  ConversionProtocol.swift
//  Currency Exchange
//
//  Created by Ivan on 16.10.2022.
//

import Foundation

protocol ConversionProtocol {
    var myBalances: [CurrencyModelProtocol] { get set }
    var conversionFrom: CurrencyModelProtocol { get }
    var conversionResponse: CurrencyModelProtocol? { get set }
    var conversionTo: CurrencyType { get }
    var conversionPercent: Double { get set }
    var conversionsCount: Int { get set }
    var freeConversionCount: Int { get }
}

protocol ConversionMessageProtocol {
    func successMessage() -> String?
    func isOperationValid() -> (isValid: Bool, error: String?)
}

protocol CurrencyOperationProtocol: ConversionProtocol, ConversionMessageProtocol {
    var calculateCommission: CurrencyModelProtocol { get }
    func calculateMyNewBalanceAfterConversion() -> [CurrencyModelProtocol]
    func decrementConversion() -> Double
    func incrementConversion() -> Double
}

