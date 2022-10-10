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

struct CurrencyConverterApiModel: Decodable {
    let amount: String
    let currency: CurrencyType
}
