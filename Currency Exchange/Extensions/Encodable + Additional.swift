//
//  Encodable + Additional.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import Foundation

extension Encodable {
    
    var toDictionary: [String: Any]? {
        
        let jsonEncoder: JSONEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        guard let backToJson: Data = try? jsonEncoder.encode(self),
            let json: Any = try? JSONSerialization.jsonObject(with: backToJson, options: .allowFragments) else {
                
                return nil
        }
        
        return json as? [String: Any]
    }
    
    var toData: Data? {
        
        let jsonEncoder: JSONEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        return try? jsonEncoder.encode(self)
    }
    
    func printJson() {
        
        let jsonEncoder: JSONEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        if let backToJson: Data = try? jsonEncoder.encode(self),
            let jsonString: String = String(data: backToJson, encoding: .utf8) {
            print(jsonString)
        }
    }
}
