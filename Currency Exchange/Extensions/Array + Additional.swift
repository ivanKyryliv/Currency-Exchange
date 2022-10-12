//
//  Array + Additional.swift
//  Currency Exchange
//
//  Created by Ivan on 12.10.2022.
//

import UIKit

extension Array {

    func objectWithClass(_ cls: AnyClass) -> AnyObject? {
        for object in self {
            let objectClass = type(of: object)
            
            if objectClass == cls {
                return object as AnyObject?
            }
        }
        
        return nil
    }
    
    func isValidIndex(_ index:Int) -> Bool {
        return 0..<count ~= index
    }
}
