//
//  ApiResponse.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

struct ApiResponse<T: Decodable> {
    
    let entity: T
    let httpUrlResponse: HTTPURLResponse
    let data: Data?
    
    init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
        do {
            let decoder = JSONDecoder()
            self.entity = try decoder.decode(T.self, from: data!)
            self.httpUrlResponse = httpUrlResponse
            self.data = data
        } catch let error {
            print("ERROR DECODABLE: \(error)")
            throw ApiParseError(error: error, httpUrlResponse: httpUrlResponse, data: data)
        }
    }
}

