//
//  InputViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 21.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

final class InputViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var logoImage: UIImageView!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.isEnabled = false
        
        logoImage.image = Asset.tloc.image
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
            case .username: configureInputView(usernameInputView, with: field)
            }
        }
    }
    
    // MARK: - Keyboard
    
    private func addObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        
        guard let userInfo = notification.userInfo,
            var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification){
        scrollView.contentInset = .zero
    }
    
    // MARK: - IBActions
    
    @IBAction func confirmAction(_ sender: Any) {
        
        guard let type = inputType else {
            return
        }
        
        switch type {
        case .forgotPassword: didConfirmForgotPassword()
        case .register:       didConfirmRegister()
        }
    }
    
    // MARK: - Helper
    
    private func configureInputView(_ inputView: InputView, with field: Field) {
        
        inputView.configure(title: field.title, delegate: textFieldDelegate, icon: field.icon, secureTextField: field.isSecure, didChanged: textFieldDidChanged)
        inputStackView.addArrangedSubview(inputView)
    }
    
    private func textFieldDidChanged() {
        
        guard let inputType = inputType else {
            return
        }
        
        switch inputType {
        case .forgotPassword:   confirmButton.isEnabled = emailInputView.isFilled
        case .register:         confirmButton.isEnabled = emailInputView.isFilled && usernameInputView.isFilled && passwordInputView.isFilled
        }
    }
    
    private func didConfirmForgotPassword() {
        
        guard let email = emailInputView.text else {
            return
        }
        
        UserService.sendPasswordReset(to: email) { (error) in
            
            guard let e = error else {
                return
            }
            print("Error reset password: \(e.localizedDescription)")
        }
    }
    
    private func didConfirmRegister() {
        
        guard let email = emailInputView.text,
            let password = passwordInputView.text,
            let username = usernameInputView.text else {
                return
        }
        
        UserService.createUser(with: email, username: username, password: password) { [weak self] (error) in
            
            if let e = error {
                print("Register error: \(e.localizedDescription)")
            } else {
                self?.showTabbar()
            }
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
    case forgotPassword
    case register
    
    var fields: [Field] {
        
        switch self {
        case .forgotPassword:   return [.email]
        case .register:         return [.email, .username, .password]
        }
    }
    
    var title: String {
        
        switch self {
        case .forgotPassword:   return "Forgot Password"
        case .register:         return "Register"
        }
    }
}

public enum Field {
    case email
    case password
    case username
    
    var title: String {
        
        switch self {
        case .email:            return "Email"
        case .password:         return "Password"
        case .username:         return "Username"
        }
    }
    
    var icon: UIImage? {
        
        switch self {
        case .email:            return Asset.email.image
        case .password:         return Asset.password.image
        case .username:         return nil
        }
    }
    
    var isSecure: Bool {
        
        switch self {
        case .email:            return false
        case .password:         return true
        case .username:         return false
        }
    }
}
    
