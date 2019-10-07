//
//  SettingsViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase

final class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var emailInputView: InputView!
    @IBOutlet private weak var nameInputView: InputView!
    @IBOutlet private weak var deleteAccountButton: BaseButton!
    @IBOutlet private weak var logoutButton: BaseButton!
    
    // MARK: - Properties
    
    private let textFieldDelegate = TextFieldDelegate()
    private var user: User? {
        didSet {
            setUserData()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        setupUI()
        setUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserService.getCurrentUser(completion: { [weak self] (user) in
            self?.user = user
        })
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        emailInputView.configure(title: "Email", delegate: textFieldDelegate, icon: Asset.email.image, secureTextField: false, didChanged: textFieldDidChanged)
        nameInputView.configure(title: "Name", delegate: textFieldDelegate, icon: nil, secureTextField: false, didChanged: textFieldDidChanged)
        deleteAccountButton.setTitle("Delete Account", for: .normal)
        logoutButton.setTitle("Logout", for: .normal)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(showActionSheet)))
    }
    
    // MARK: - IBActions
    
    @IBAction func deleteAction(_ sender: Any) {
        
        showAlert(with: Alerts.DeleteAlertTitle, message: Alerts.DeleteAlertDescription) { [weak self] in
 
            UserService.deleteUser(completion: { (error) in
                
                if let error = error {
                    self?.showAlert(with: Alerts.ErrorTitle, message: error.localizedDescription)
                } else {
                    self?.showLogin()
                }
            })
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        UserService.logout { [weak self] (success) in
            
            if success {
                self?.showLogin()
            } else {
                self?.showAlert(with: Alerts.ErrorTitle, message: Alerts.LogoutErrorDescription)
            }
        }
    }
    
    // MARK: - Helper
    
    @objc private func showActionSheet() {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose an Option", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (_) in
            self?.presentImagePicker(with: .camera)
        }
        let albumAction = UIAlertAction(title: "Album", style: .default) { [weak self] (_) in
            self?.presentImagePicker(with: .photoLibrary)
        }
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(albumAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func setUserData() {
    
        #warning("REMOVE")
        profileImageView.image = Asset.paul.image
        profileImageView.contentMode = .scaleAspectFill
        emailInputView.text = user?.email
        nameInputView.text = user?.name
    }
    
    private func textFieldDidChanged() {
    
        // TODO: - savebutton in navbar wenn user daten anders
    }
    
    private func showLogin() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        appDelegate.setLoginToRoot()
    }
    
    private func presentImagePicker(with sourceType: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - StoryboardInitializable

extension SettingsViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> SettingsViewController {
        return StoryboardScene.Main.settingsViewController.instantiate()
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            profileImageView.image = image
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
        
        dismiss(animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: false, completion: nil)
    }
}
