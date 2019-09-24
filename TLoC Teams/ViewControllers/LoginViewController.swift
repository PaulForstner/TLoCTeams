//
//  LoginViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 18.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var logoContainerView: UIView!
    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var emailInputView: InputView!
    @IBOutlet private weak var passwordInputView: InputView!
    @IBOutlet private weak var loginButton: BaseButton!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    // MARK: - Properties
    
    private let textFieldDelegate = TextFieldDelegate()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    // MARK: - Setup
    
    private func setupUI() {
        
        emailInputView.configure(title: "Email", delegate: textFieldDelegate, icon: nil)
        passwordInputView.configure(title: "Password", delegate: textFieldDelegate, icon: nil, secureTextField: true)
        
        loginButton.setTitle("Login", for: .normal)
        setupBlackButton(forgotPasswordButton, with: "Forgot password?")
        setupBlackButton(registerButton, with: "Not registered yet? Sign up!")
    }
    
    private func setupBlackButton(_ button: UIButton, with title: String) {
        
        button.setTitle(title, for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }

    // MARK: - IBActions
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard validateInput(), let email = emailInputView.text, let password = passwordInputView.text else {
            return
        }
        
        UserService.login(with: email, password: password) { [weak self] (error) in
            
            if let e = error {
                print("Login error: \(e.localizedDescription)")
            } else {
                self?.showTabbar()
            }
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        showInputView(with: .forgotPassword)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        showInputView(with: .register)
    }
    
    // MARK: - Helper
    
    private func showTabbar() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        appDelegate.setTabBarToRoot()
    }
    
    private func showInputView(with inputType: InputType) {
        
        let vc = InputViewController.makeFromStoryboard(with: inputType)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Returns true if the input is valid and false if it is invalid
    private func validateInput() -> Bool {
        
        guard emailInputView.isFilled && passwordInputView.isFilled else {
            return false
        }
        
        // TODO: Email validation
        
        return true
    }
}

// MARK: - StoryboardInitializable

extension LoginViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> LoginViewController {
        return StoryboardScene.Main.loginViewController.instantiate()
    }
}
