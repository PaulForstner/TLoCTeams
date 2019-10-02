//
//  InputView.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 20.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class InputView: BaseView {

    // MARK: - Typealias
    
    typealias ChangedHandler = () -> Void
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var textFieldImage: UIImageView!
    
    // MARK: - Properties
    
    private var didChanged: ChangedHandler?
    
    public var isFilled: Bool {
        get {
            return textField.text?.count ?? 0 > 0
        }
    }
    
    public var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    // MARK: - Setup
    
    public override func setupUI() {
        
        textField.borderStyle = .none
        textFieldImage.tintColor = ColorName.green.color
        
        titleLabel.textColor = ColorName.green.color
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    // MARK: - TextField
    
    @IBAction func textFieldDidChanged(_ sender: Any) {
        didChanged?()
    }
    
    // MARK: - Configure
    
    public func configure(title: String, delegate: UITextFieldDelegate?, icon: UIImage?, secureTextField: Bool = false, didChanged: ChangedHandler?) {
        
        textField.placeholder = title
        textField.delegate = delegate
        textField.isSecureTextEntry = secureTextField
        textFieldImage.image = icon?.withRenderingMode(.alwaysTemplate)
        textFieldImage.isHidden = textFieldImage.image == nil ? true : false
        titleLabel.text = title
        
        self.didChanged = didChanged
    }
}
