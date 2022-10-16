//
//  CurrencyConverterApiModel.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

enum CurrencyType: String, Codable {
    case EUR
    case USD
    case JPY
}

protocol CurrencyModelProtocol: Codable {
    var amount: Double { get set }
    var currency: CurrencyType { get set }
    func toString() -> String
}

struct CurrencyApiModel: CurrencyModelProtocol {
    enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }
    
    var amount: Double
    var currency: CurrencyType
    
    func toString() -> String {
        let amount = String(format: currency == .JPY ? "%.f" : "%.2f", amount)
        return "\(amount) \(currency.rawValue)"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currency = try values.decode(CurrencyType.self, forKey: .currency)
        let amountString = try values.decode(String.self, forKey: .amount)
        amount = Double(amountString) ?? 0.0
    }
    
    init(amount: Double, currency: CurrencyType) {
        self.amount = amount
        self.currency = currency
    }
}
