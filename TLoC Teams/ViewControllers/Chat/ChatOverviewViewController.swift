//
//  ChatOverviewViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase

final class ChatOverviewViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lazy
    
    private lazy var dataSource: ChatOverviewDataSource = {
        return ChatOverviewDataSource(didSelectHandler: { [weak self] (item) in
            self?.showChat(item)
        }, updateHandler: { [weak self] in
            self?.tableView.reloadData()
        })
    }()
    // MARK: - Properties
    
    private var chatReference: DatabaseReference?
    private var chatHandler: DatabaseHandle?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configure(tableView: tableView)
        setupDatabase()
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
     
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createChatRoom))
        addButton.tintColor = ColorName.green.color
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    private func setupDatabase() {
        chatReference = Database.database().reference().child("chats")
        
        chatHandler = chatReference?.observe(.childAdded) { [weak self] (snapshot: DataSnapshot) in
            
            guard let chat = MappingHelper.mapChat(from: snapshot.value, id: snapshot.key) else {
                return
            }
            
            self?.dataSource.append(chat)
            //                        self?.tableView.insertRows(at: [IndexPath(row: self?.messages.count-1, section: 0)], with: .automatic)
            //            self?.scrollToBottomMessage()
        }
        
//
//        chatHandler = chatReference?.child("rooms").observe(.childChanged) { [weak self] (snapshot: DataSnapshot) in
//
//        }
//
//        chatHandler = chatReference?.child("rooms").observe(.childRemoved) { [weak self] (snapshot: DataSnapshot) in
//
//        }
        
        
    }
    
    // MARK: - Helper
    
    @objc private func createChatRoom() {
        
        let chatName = "Chat\(tableView.visibleCells.count)"
        let data: [String: Any] = ["name": chatName,
                                   "members": [:],
                                   "messages": [:]]
        chatReference?.childByAutoId().setValue(data)
    }
    
    private func showChat(_ chat: Chat) {
        
    }
}

// MARK: - StoryboardInitializable

extension ChatOverviewViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> ChatOverviewViewController {
        return StoryboardScene.Main.chatOverviewViewController.instantiate()
    }
}
