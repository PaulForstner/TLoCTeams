//
//  SeparatorView.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 20.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class SeparatorView: UIView {
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = ColorName.gray.color
    }
}
