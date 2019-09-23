//
//  TextFieldDelegate.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 21.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

