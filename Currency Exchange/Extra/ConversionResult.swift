//
//  ConversionResult.swift
//  Currency Exchange
//
//  Created by Ivan on 16.10.2022.
//

import Foundation

struct ConversionResult: CurrencyConversionsProtocol {
    func currencyConversion(fromAmount: Double,
                            fromCurrency: CurrencyType,
                            toCurrency: CurrencyType,
                            completionHandler: @escaping (CurrencyModelProtocol?, String?) -> Void) {
        
        let currencyRequest = CurrencyRequest(fromAmount: fromAmount,
                                              fromCurrency: fromCurrency,
                                              toCurrency: toCurrency)
        
        let fetchConversions = FetchConversions(currencyRequest: currencyRequest)
        
        NetworkService.shared.performApiRequest(fetchConversions) {
            (result: Result<ApiResponse<CurrencyApiModel>>) in
            switch result {
            case .success(let response):
                completionHandler(response.entity, nil)
            case let .failure(error):
                completionHandler(nil, error.errorMessage)
            }
        }
    }
}
