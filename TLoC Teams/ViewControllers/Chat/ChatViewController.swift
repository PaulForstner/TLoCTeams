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
    @IBOutlet private weak var textFieldContainerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Lazy
    
    private lazy var dataSource: ChatDataSource = {
        return ChatDataSource(addMessageHandler: { [weak self] (index) in
            
            self?.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            self?.scrollToBottomMessage()
        })
    }()
    
    private lazy var titleButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle(chat?.name, for: .normal)
        button.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    private var chat: Chat?
    private var user: User?
    private var chatReference: DatabaseReference?
    private var memberHandler: DatabaseHandle?
    private let dateFormatter = DateFormatter()
    
    // MARK: - Life cycle
    
    deinit {
        chatReference?.removeAllObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configure(tableView: tableView)
        setupDatabase()
        setupUI()
        setupUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver()
        
        if let chat = chat {
            titleButton.setTitle(chat.name, for: .normal)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        sendButton.isEnabled = false
        sendButton.setImage(Asset.send.image, for: .normal)
        sendButton.tintColor = ColorName.green.color
        
        textField.delegate = self
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        navigationItem.titleView = titleButton
    }
    
    private func setupDatabase() {
        
        guard let chat = chat else {
            return
        }
        
        chatReference = Database.database().reference().child("chats").child(chat.id)
        chatReference?.keepSynced(true)
        
        chatReference?.child(Constants.ChatFields.messages).observe(.childAdded) { [weak self] (snapshot: DataSnapshot) in
            
            guard let message = MappingHelper.mapMessage(from: snapshot) else {
                return
            }
            self?.dataSource.append(message)
        }
        
        chatReference?.observe(.childChanged, with: { [weak self] (snapshot) in
            
            guard snapshot.key == Constants.ChatFields.name else {
                return
            }
            
            self?.chat?.name = snapshot.value as? String ?? ""
        })
    }
    
    private func setupUser() {
        UserService.getCurrentUser(completion: { [weak self] (user) in
            self?.user = user
        })
    }
    
    // MARK: - Keyboard
    
    private func addObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
            var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
        }
        
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        UIView.animate(withDuration: animationDurarion) {
            
            self.textFieldContainerViewBottomConstraint.constant = -keyboardFrame.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
            let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
        }

        UIView.animate(withDuration: animationDurarion) {
            
            self.textFieldContainerViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
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
        
        send(message: text)
    }
    
    // MARK: - Helper
    
    @objc private func showDetail() {
        
        guard let chat = chat else {
            return
        }
        
        view.endEditing(true)
        let vc = ChatDetailViewController.makeFromStoryboard(with: chat, clearHandler: { [weak self] in
            self?.dataSource.set([])
        })
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func scrollToBottomMessage() {

        let rows = tableView.numberOfRows(inSection: 0)
        
        guard rows > 0 else {
            return
        }
        
        let lastIndex = IndexPath(row: rows - 1, section: 0)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }
    
    private func send(message: String) {
        
        guard let user = user, let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let message = Message(date: dateFormatter.string(from: Date()), sender: user.name, senderId: userId, id: "", text: message)
        chatReference?.child(Constants.ChatFields.messages).childByAutoId().setValue(message.dictionary)
        textField.text = ""
        sendButton.isEnabled = false
    }
}

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

// MARK: - Extension

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
