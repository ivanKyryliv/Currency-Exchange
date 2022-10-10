//
//  RootViewProtocol.swift
//  Currency Exchange
//
//  Created by Ivan on 10.10.2022.
//

import UIKit

protocol RootViewGettable {
    
    associatedtype RootViewType: UIView
    
    var rootView: RootViewType? { get }
}

extension RootViewGettable where Self : UIViewController {
    
    var rootView: RootViewType? { return self.view as? RootViewType }
}

