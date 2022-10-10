//
//  ApiParseError.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

struct ApiParseError: Error {
 
    let error: Error
    let httpUrlResponse: HTTPURLResponse
    let data: Data?
    
    var localizedDescription: String {
        return error.localizedDescription
    }
}
