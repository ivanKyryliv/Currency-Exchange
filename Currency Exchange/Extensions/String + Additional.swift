//
//  String + Additional.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension String {
    func isValidDouble(maxDecimalPlaces: Int, maxDigits: Int) -> Bool {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        let decimalSeparator = formatter.decimalSeparator ?? "."
        
        if formatter.number(from: self) != nil {
            let split = self.components(separatedBy: decimalSeparator)
            let digits = split.count == 2 ? split.last ?? "" : ""
            return digits.count <= maxDecimalPlaces && split.first?.count ?? 0 <= maxDigits
        }
        
        return false
    }
}
