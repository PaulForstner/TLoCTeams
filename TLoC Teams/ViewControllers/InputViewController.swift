//
//  InputViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 21.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

final class InputViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var inputStackView: UIStackView!
    @IBOutlet private weak var confirmButton: BaseButton!
    
    // MARK: - Lazy
    
    private lazy var textFieldDelegate: TextFieldDelegate = {
        return TextFieldDelegate()
    }()
    
    private lazy var emailInputView: InputView = {
        return InputView()
    }()
    
    private lazy var passwordInputView: InputView = {
        return InputView()
    }()
    
    private lazy var currentPasswordInputView: InputView = {
        return InputView()
    }()
    
    private lazy var newPasswordInputView: InputView = {
        return InputView()
    }()
    
    private lazy var usernameInputView: InputView = {
        return InputView()
    }()
    
    // MARK: - Properties
    
    private var inputType: InputType?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupInputType()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        confirmButton.setTitle("Confirm", for: .normal)
    }
    
    private func setupInputType() {
        
        guard let type = inputType else {
            return
        }
        
        for inputView in inputStackView.subviews {
            inputView.removeFromSuperview()
        }
        
        title = type.title
        
        for field in type.fields {
            
            switch field {
            case .email: configureInputView(emailInputView, with: field)
            case .password: configureInputView(passwordInputView, with: field)
            case .currentPassword: configureInputView(currentPasswordInputView, with: field)
            case .newPassword: configureInputView(newPasswordInputView, with: field)
            case .username: configureInputView(usernameInputView, with: field)
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func confirmAction(_ sender: Any) {
        
        guard let type = inputType else {
            return
        }
        
        switch type {
        case .changePassword: didConfirmChangePassword()
        case .forgotPassword: didConfirmForgotPassword()
        case .register:       didConfirmRegister()
        }
    }
    
    // MARK: - Helper
    
    private func configureInputView(_ inputView: InputView, with field: Field) {
        
        inputView.configure(title: field.title, delegate: textFieldDelegate, icon: field.icon, secureTextField: field.isSecure)
        inputStackView.addArrangedSubview(inputView)
    }
    
    private func didConfirmChangePassword() {
        
        guard currentPasswordInputView.isFilled && newPasswordInputView.isFilled else {
            return
        }
        
    }
    
    private func didConfirmForgotPassword() {
        
        guard let email = emailInputView.text else {
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if let e = error {
                print("Error saving channel: \(e.localizedDescription)")
            }
        }
    }
    
    private func didConfirmRegister() {
        
        guard let email = emailInputView.text,
            let password = passwordInputView.text,
            let username = usernameInputView.text else {
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            
            guard let id = result?.user.uid else {
                return
            }
            let db = Firestore.firestore()
            let data = [Constants.UserFields.name: username]
            db.collection("users").addDocument(data: [id: data], completion: { (error) in
                
                if let e = error {
                    print("Error saving channel: \(e.localizedDescription)")
                }
            })
            self?.showTabbar()
        }
    }
    
    private func showTabbar() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        appDelegate.setTabBarToRoot()
    }
}

// MARK: - StoryboardInitializable

extension InputViewController: StoryboardInitializable {

    static func makeFromStoryboard() -> InputViewController {
        return StoryboardScene.Main.inputViewController.instantiate()
    }
    
    static func makeFromStoryboard(with inputType: InputType) -> InputViewController {
        
        let vc = makeFromStoryboard()
        vc.inputType = inputType
        return vc
    }
}

// MARK: - UITextFieldDelegate

extension InputViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Enum

public enum InputType {
    case changePassword
    case forgotPassword
    case register
    
    var fields: [Field] {
        
        switch self {
        case .changePassword:    return [.currentPassword, .newPassword]
        case .forgotPassword:   return [.email]
        case .register:         return [.email, .username, .password]
        }
    }
    
    var title: String {
        
        switch self {
        case .changePassword:    return "Change Password"
        case .forgotPassword:   return "Forgot Password"
        case .register:         return "Register"
        }
    }
}

public enum Field {
    case email
    case password
    case currentPassword
    case newPassword
    case username
    
    var title: String {
        
        switch self {
        case .email:            return "Email"
        case .password:         return "Password"
        case .currentPassword:  return "Current password"
        case .newPassword:      return "New password"
        case .username:         return "Username"
        }
    }
    
    var icon: UIImage? {
        
        switch self {
        case .email:            return nil
        case .password:         return nil
        case .currentPassword:  return nil
        case .newPassword:      return nil
        case .username:         return nil
        }
    }
    
    var isSecure: Bool {
        
        switch self {
        case .email:            return false
        case .password:         return true
        case .currentPassword:  return true
        case .newPassword:      return true
        case .username:         return false
        }
    }
}
    
