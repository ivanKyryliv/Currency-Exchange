//
//  ApiError.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

struct ApiError: ApiErrorParsable {
    let data: Data?
    let httpUrlResponse: HTTPURLResponse
    var errorMessage: String {
        let messageErrorBody = try? JSONDecoder().decode(MessageErrorBody.self, from: data!)
        return messageErrorBody?.message ?? "Unknown error occured"
    }
}
