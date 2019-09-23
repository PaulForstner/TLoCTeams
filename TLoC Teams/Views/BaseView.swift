//
//  BaseView.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 20.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    // MARK: - Initializers
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    
    private func commonInit() {
        
        let bundle = Bundle(for: type(of: self))
        
        guard bundle.path(forResource: String(describing: type(of: self)), ofType: "nib") != nil else {
            return
        }
        
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
        
        setupUI()
    }
    
    
    // MARK: - Setup
    
    open func setupUI() {
        
        // override in subclass
    }
}
