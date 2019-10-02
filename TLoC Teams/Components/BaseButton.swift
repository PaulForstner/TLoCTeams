//
//  BaseButton.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 20.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
    
    // MARK: - Typealias
    
    typealias ActionHandler = () -> Void
    
    // MARK: - Struct
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let backgroundColor = ColorName.green.color.withAlphaComponent(0.7)
        static let selectedColor = ColorName.green.color.withAlphaComponent(0.6)
        static let titleSelectedColor = ColorName.darkGreen.color.withAlphaComponent(0.4)
    }
    
    // MARK: - Properties
    
    private var onClickHandler: ActionHandler?
    private var gradientLayer: CAGradientLayer?
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
    
    public init(title: String, onClickHandler: @escaping ActionHandler) {
        super.init(frame: .zero)
        
        setupUI()
        self.onClickHandler = onClickHandler
        configure(with: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer?.frame = bounds
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
        self.gradientLayer = gradientLayer
    }
    
    private func configure(with title: String) {
        
        setTitle(title, for: .normal)
        setTitleColor(ColorName.darkGreen.color, for: .normal)
        setTitleColor(Constants.titleSelectedColor, for: .highlighted)
        setTitleColor(Constants.titleSelectedColor, for: .disabled)
        addTarget(self, action: #selector(onClick), for: .touchUpInside)
        NSLayoutConstraint.activate([ heightAnchor.constraint(equalToConstant: 40) ])
    }
    
    // MARK: - Button
    
    @objc private func onClick() {
        onClickHandler?()
    }
}
