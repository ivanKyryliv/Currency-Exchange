//
//  ApiEndPoint.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

class ApiEndPoint {
    static func convertCurrency(fromAmount: Double, fromCurrency: CurrencyType, toCurrency: CurrencyType) -> URL {
        return URL(string: "\(NetworkService.serverBaseUrl)currency/commercial/exchange/\(fromAmount)-\(fromCurrency.rawValue)/\(toCurrency.rawValue)/latest")!
    }
}
