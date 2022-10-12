//
//  UINib + Additional.swift
//  Currency Exchange
//
//  Created by Ivan on 12.10.2022.
//

import UIKit

extension UINib {
    class func objectWithClass(_ cls: AnyClass) -> AnyObject? {
        let nib = self.nibWithClass(cls)
        
        return nib.objectWithClass(cls)
    }
    
    class func nibWithClass(_ cls: AnyClass) -> UINib {
        return self.nibWithClass(cls, nibBundle: nil)
    }
    
    class func nibWithClass(_ cls: AnyClass, nibBundle bundle: Bundle?) -> UINib {
        return self.init(nibName: String(describing: cls.self), bundle: bundle)
    }

    func objectWithClass(_ cls: AnyClass) -> AnyObject? {
        return objectWithClass(cls, with: nil, and: nil)
    }
    
    func objectWithClass(_ cls: AnyClass, with owner: Any?, and options: [UINib.OptionsKey : Any]?) -> AnyObject? {
        return self.instantiate(withOwner: owner, options: options).objectWithClass(cls) as AnyObject?
    }
}
