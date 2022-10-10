//
//  URLRequest + Init.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

extension URLRequest {
    
    init(url: URL, method: HTTPMethod, parameters: Codable? = nil, headers: Codable? = nil) {
        
        var tempURL: URL = url
        var httpBodyParameters: Data?
        
        let isEncodesParametersInURL: Bool = method == .get || method == .delete
        if isEncodesParametersInURL {
            if let queryParameters: [String: Any] = parameters?.toDictionary, var components: URLComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) {
                
                var queryItems: [URLQueryItem] = []
                queryParameters.forEach { key, value in
                    if let value = value as? [Any] {
                        value.forEach({
                            queryItems.append(URLQueryItem(name: "\(key)[]", value: "\($0)"))
                        })
                    } else {
                        queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                    }
                }
                components.queryItems = queryItems
                tempURL = components.url ?? url
            }
        } else {
            httpBodyParameters = parameters?.toData
        }
        
        self.init(url: tempURL)
        httpMethod = method.rawValue
        
        if let httpBodyParameters = httpBodyParameters {
            setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            httpBody = httpBodyParameters
        }
        
        if let headers = headers?.toDictionary {
            headers.forEach({
                addValue("\($0.value)", forHTTPHeaderField: $0.key)
            })
        }
    }
}
