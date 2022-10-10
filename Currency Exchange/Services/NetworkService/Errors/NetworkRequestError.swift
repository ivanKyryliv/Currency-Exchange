//
//  NetworkRequestError.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

struct NetworkRequestError: ApiErrorParsable {
    let error: Error?
    var errorMessage: String {
        return error?.localizedDescription ?? "Network request error"
    }
}
