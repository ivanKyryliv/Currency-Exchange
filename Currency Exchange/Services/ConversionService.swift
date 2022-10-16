//
//  ConversionService.swift
//  Currency Exchange
//
//  Created by Ivan on 16.10.2022.
//

import Foundation

class ConversionService {
    
    func newBalancesAfterConversion(_ operation: CurrencyOperationProtocol) -> [CurrencyModelProtocol] {
        return operation.calculateMyNewBalanceAfterConversion()
    }
    
    func isOperationValid(_ operation: CurrencyOperationProtocol) -> (isValid: Bool, error: String?) {
        return operation.isOperationValid()
    }
    
    func showSuccessMessage(_ operation: CurrencyOperationProtocol) -> String? {
        return operation.successMessage()
    }
}
