//
//  BaseButton.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 20.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class BaseButton: UIButton {

    // MARK: - Struct
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let backgroundColor = ColorName.green.color.withAlphaComponent(0.7)
        static let selectedColor = ColorName.green.color.withAlphaComponent(0.6)
    }
    
    // MARK: - Properties
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? Constants.selectedColor : Constants.backgroundColor
        }
    }
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        backgroundColor     = Constants.backgroundColor
        layer.cornerRadius  = Constants.cornerRadius
        layer.masksToBounds = true
        layer.borderWidth   = 1
        layer.borderColor   = ColorName.darkGreen.color.cgColor
        tintColor           = ColorName.darkGreen.color
        setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.5).cgColor,
            Constants.backgroundColor.cgColor
        ]
        layer.addSublayer(gradientLayer)
    }
}
