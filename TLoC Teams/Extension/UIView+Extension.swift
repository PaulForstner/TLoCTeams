//
//  UIView+Extension.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 20.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

public extension UIView {
    
    class func loadFromNib<T: UIView>(with bundle: Bundle = Bundle.main) -> T {
        
        let nibName: String = String(describing: T.self)
        
        guard let view = bundle.loadNibNamed(nibName, owner: nil, options: nil)?.first as? T else {
            fatalError("UIView \(T.self) isn't in \(String(describing: bundle.bundleIdentifier)) bundle")
        }
        
        return view
    }
}
