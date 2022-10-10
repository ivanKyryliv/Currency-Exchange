//
//  ApiStatusCode.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

enum ApiStatusCode {
    static let successRange = 200...299
    static let unauthenticatedRange: [Int] = [401, 403]
    static let noContentStatusCode = 204
    static let serverErrorRange = 500...
    static let noInternetConnection = -1009
}
