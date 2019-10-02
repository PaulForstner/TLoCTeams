//
//  CreateEventViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 01.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase

final class CreateEventViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var setImageButton: UIButton!
    @IBOutlet private weak var eventNameInputView: InputView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var gameHelperView: UIView!
    @IBOutlet private weak var gameLabel: UILabel!
    @IBOutlet private weak var locationHelperView: UIView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var createButton: BaseButton!
    
    // MARK: - Properties
    
    private var eventReference: DatabaseReference?
    private let textFieldDelegate = TextFieldDelegate()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDatabase()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        eventNameInputView.configure(title: "Name", delegate: textFieldDelegate, icon: nil, didChanged: textFieldDidChanged)
    }
    
    private func setupDatabase() {
        
    }
    
    // MARK: - IBAction
    
    @IBAction func setImageAction(_ sender: Any) {
        
    }
    
    // MARK: - Helper
    
    @objc private func create() {
        
        guard let name = eventNameInputView.text else {
            return
        }
        
//        let chat = Chat(name: name, id: "", imageUrl: "", messages: [])
//        chatsReference?.childByAutoId().setValue(chat.dictionary)
//        navigationController?.popViewController(animated: true)
    }
    
    private func textFieldDidChanged() {

        createButton.isEnabled = eventNameInputView.isFilled
    }
}

// MARK: - StoryboardInitializable

extension CreateEventViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> CreateEventViewController {
        return StoryboardScene.Main.createEventViewController.instantiate()
    }
}

