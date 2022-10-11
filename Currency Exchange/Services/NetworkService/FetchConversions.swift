//
//  FetchConversions.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

struct FetchConversions: RequestBuilder {
    
    var currencyRequest: CurrencyRequest
    
    init(currencyRequest: CurrencyRequest) {
        self.currencyRequest = currencyRequest
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: URL {
        return ApiEndPoint.convertCurrency(fromAmount: currencyRequest.fromAmount,
                                           fromCurrency: currencyRequest.fromCurrency,
                                           toCurrency: currencyRequest.toCurrency)
    }
    
    func build() -> URLRequest {
        let request = URLRequest(url: path, method: method, parameters: nil, headers: headers)
        return request
    }
}
