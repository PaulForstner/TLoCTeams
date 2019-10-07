//
//  ChatDetailViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 27.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase

final class ChatDetailViewController: UIViewController {

    // MARK: - Typealias
    
    typealias ClearHandler = () -> Void
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var groupImageView: UIImageView!
    @IBOutlet private weak var groupNameInputView: InputView!
    @IBOutlet private weak var setImageButton: UIButton!
    
    // MARK: - Lazy
    
    private lazy var createButton: BaseButton = {
        return BaseButton(title: "Create", onClickHandler: create)
    }()
    
    private lazy var deleteButton: BaseButton = {
        return BaseButton(title: "Delete", onClickHandler: deleteGroup)
    }()
    
    private lazy var clearHistoryButton: BaseButton = {
        return BaseButton(title: "Clear history", onClickHandler: clearHistory)
    }()
    
    // MARK: - Properties
    
    private var chat: Chat?
    private var chatsReference: DatabaseReference?
    private var clearHandler: ClearHandler?
    private let textFieldDelegate = TextFieldDelegate()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupDatabase()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        groupNameInputView.configure(title: "Name", delegate: textFieldDelegate, icon: nil, didChanged: textFieldDidChanged)
        groupNameInputView.text = chat?.name
        
        if chat == nil {
            title = "Create Chat"
            stackView.addArrangedSubview(createButton)
            createButton.isEnabled = false
        } else {
            title = "Chat Detail"
            stackView.addArrangedSubview(clearHistoryButton)
            stackView.addArrangedSubview(deleteButton)
        }
    }
    
    private func setupDatabase() {
        
        chatsReference = Database.database().reference().child("chats")
        chatsReference?.keepSynced(true)
    }
    
    // MARK: - IBAction
    
    @IBAction func setImageAction(_ sender: Any) {
        
    }
    
    // MARK: - Helper
    
    @objc private func create() {
        
        guard let name = groupNameInputView.text else {
            return
        }
        
        let chat = Chat(name: name, id: "", imageUrl: "", messages: [])
        chatsReference?.childByAutoId().setValue(chat.dictionary)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteGroup() {
        
        guard let chat = chat else {
            return
        }
        
        chatsReference?.child(chat.id).removeValue()
        
        guard let vcCount = navigationController?.viewControllers.count else {
            return
        }
        
        navigationController?.viewControllers.remove(at: vcCount - 2)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clearHistory() {
        
        guard let chat = chat else {
            return
        }
        
        chatsReference?.child(chat.id).child(Constants.ChatFields.messages).removeValue()
        clearHandler?()
    }
    
    private func textFieldDidChanged() {
        
        guard chat == nil else {
            return
        }
        
        createButton.isEnabled = groupNameInputView.isFilled
    }
}

// MARK: - StoryboardInitializable

extension ChatDetailViewController: StoryboardInitializable {

    static func makeFromStoryboard() -> ChatDetailViewController {
        return StoryboardScene.Main.chatDetailViewController.instantiate()
    }
    
    static func makeFromStoryboard(with chat: Chat, clearHandler: ClearHandler?) -> ChatDetailViewController {
        
        let vc = StoryboardScene.Main.chatDetailViewController.instantiate()
        vc.clearHandler = clearHandler
        vc.chat = chat
        return vc
    }
}
