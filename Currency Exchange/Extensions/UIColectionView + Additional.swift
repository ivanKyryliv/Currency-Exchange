//
//  UIColectionView + Additional.swift
//  Currency Exchange
//
//  Created by Ivan on 12.10.2022.
//

import UIKit

 extension UICollectionView {
    
    func dequeueCellWithClass<T>(_ cls: T.Type,  path: IndexPath) -> T {
        let clsString = String(describing: cls.self)
        return self.dequeueReusableCell(withReuseIdentifier: clsString, for: path) as! T
    }
    
    func registerCell(withClass cls: AnyClass?) {
        if let cls = cls {
            self.register(UINib.nibWithClass(cls), forCellWithReuseIdentifier: String(describing: cls.self))
        }
    }
}
