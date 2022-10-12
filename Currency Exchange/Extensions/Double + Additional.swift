//
//  Double + Additional.swift
//  Currency Exchange
//
//  Created by Ivan on 12.10.2022.
//

import Foundation

extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}

