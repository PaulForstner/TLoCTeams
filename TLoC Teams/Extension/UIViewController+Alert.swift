//
//  UIViewController+Alert.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 28.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(with title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(with title: String, message: String, action: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.Ok, style: .default, handler: { (_) in
            action()
        }))
        alert.addAction(UIAlertAction(title: Alerts.Cancel, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
