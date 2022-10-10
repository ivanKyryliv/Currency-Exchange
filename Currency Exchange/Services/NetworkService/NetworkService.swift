//
//  NetworkService.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

protocol RequestBuilder {
    func build() -> URLRequest
    var method: HTTPMethod { get }
    var path: URL { get }
    var headers : [String: String] { get }
}

protocol ApiErrorParsable {
    var errorMessage: String { get }
}

enum Result<T> {
    case success(T)
    case failure(ApiErrorParsable)
}

final class NetworkService {
    //MARK: - Properties
    static let shared = NetworkService()
    
#if DEV
    static let serverBaseUrl = "http://api.evp.lt/"
#elseif PROD
    static let serverBaseUrl = "http://api.evp.lt/"
#endif
    
    private let urlSession: URLSession
    
    //MARK: - Lifecycle
    private init () {
        urlSession = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    }
    
    // MARK: - Private
    private func performApiRequest<T>(_ model: RequestBuilder, completion: @escaping (Result<ApiResponse<T>>) -> Void) {
        let request = model.build()
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkRequestError(error: error)))
                return
            }
            print("Server Response \(String(data: data ?? Data(), encoding: .utf8) ?? "") with status code \(httpUrlResponse.statusCode)")
            if ApiStatusCode.successRange.contains(httpUrlResponse.statusCode) {
                do {
                    let response = try ApiResponse<T>(data: data, httpUrlResponse: httpUrlResponse)
                    completion(.success(response))
                } catch {
                    completion(.failure(NetworkRequestError(error: error)))
                }
            } else if ApiStatusCode.serverErrorRange.contains(httpUrlResponse.statusCode) {
                let error = NSError(domain: "Internal server error", code: httpUrlResponse.statusCode)
                completion(.failure(NetworkRequestError(error: error)))
            } else if ApiStatusCode.unauthenticatedRange.contains(httpUrlResponse.statusCode) {
                completion(.failure(ApiError(data: data, httpUrlResponse: httpUrlResponse)))
            } else {
                completion(.failure(ApiError(data: data, httpUrlResponse: httpUrlResponse)))
            }
        }
        dataTask.resume()
    }
    
}
