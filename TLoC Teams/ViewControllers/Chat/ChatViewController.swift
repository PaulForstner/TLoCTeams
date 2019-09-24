//
//  ChatViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase

final class ChatViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textFieldContainerView: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var sendExtraButton: UIButton!
    @IBOutlet private weak var textFieldContainerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Lazy
    
    private lazy var dataSource: ChatDataSource = {
        return ChatDataSource(didSelectHandler: { (item) in
            
        }, updateHandler: { [weak self] in
            self?.tableView.reloadData()
        })
    }()
    
    // MARK: - Properties
    
    private var chat: Chat?
    private var chatReference: DatabaseReference?
    private var messagesHandler: DatabaseHandle?
    private var memberHandler: DatabaseHandle?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configure(tableView: tableView)
        setupDatabase()
    }
    
    deinit {
        guard let messagesHandler = self.messagesHandler else {
            return
        }
        
        chatReference?.removeObserver(withHandle: messagesHandler)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        sendButton.isEnabled = false
    }
    
    private func setupDatabase() {
        
        guard let chat = self.chat else {
            return
        }
        
        chatReference = Database.database().reference().child("chats").child(chat.id)
        
        messagesHandler = chatReference?.child(Constants.ChatFields.messages).observe(.childAdded) { [weak self] (snapshot: DataSnapshot) in
            
            guard let message = MappingHelper.mapMessage(from: snapshot) else {
                return
            }
            self?.dataSource.append(message)
            self?.tableView.reloadData()
//                        self?.tableView.insertRows(at: [IndexPath(row: self?.messages.count-1, section: 0)], with: .automatic)
            self?.scrollToBottomMessage()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func textFieldDidChanged(_ sender: Any) {
        sendButton.isEnabled = textField.text?.isEmpty == false
    }
    
    @IBAction func sendAction(_ sender: Any) {
        
        guard let text = textField.text else {
            return
        }
        
        let message = Message(sender: "Test", id: "", text: text)
        chatReference?.child(Constants.ChatFields.messages).childByAutoId().setValue(message.dictionary)
    }
    
    @IBAction func sendExtraAction(_ sender: Any) {
        
    }
    
    // MARK: - Helper
    
    
    private func scrollToBottomMessage() {
//        if messages.count == 0 { return }
//        let bottomMessageIndex = IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)
//        tableView.scrollToRow(at: bottomMessageIndex, at: .bottom, animated: true)
    }
}

// MARK: - 

// MARK: - StoryboardInitializable

extension ChatViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> ChatViewController {
        return StoryboardScene.Main.chatViewController.instantiate()
    }
    
    static func makeFromStoryboard(chat: Chat) -> ChatViewController {
        
        let vc = StoryboardScene.Main.chatViewController.instantiate()
        vc.chat = chat
        return vc
    }
}
