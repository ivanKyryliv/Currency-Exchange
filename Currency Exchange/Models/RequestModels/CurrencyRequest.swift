//
//  CurrencyRequest.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

struct CurrencyRequest: Codable {
    var fromAmount: Double
    var fromCurrency: String
    var toCurrency: String
}
