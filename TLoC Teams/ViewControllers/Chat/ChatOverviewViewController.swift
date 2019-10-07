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
            
            let vc = ChatViewController.makeFromStoryboard(chat: item)
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }, updateHandler: { [weak self] in
            self?.tableView.reloadData()
        })
    }()
    // MARK: - Properties
    
    private var chatsReference: DatabaseReference?
    private var chatsHandler: DatabaseHandle?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configure(tableView: tableView)
        setupDatabase()
        setupUI()
    }
    
    deinit {
        guard let chatHandler = chatsHandler else {
            return
        }
        
        chatsReference?.removeObserver(withHandle: chatHandler)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
     
        title = "Chats"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateChat))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupDatabase() {
        chatsReference = Database.database().reference().child("chats")
        chatsReference?.keepSynced(true)
        
        chatsHandler = chatsReference?.observe(.childAdded) { [weak self] (snapshot: DataSnapshot) in
            
            guard let chat = MappingHelper.mapChat(from: snapshot) else {
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
    
    @objc private func showCreateChat() {
        
        let vc = ChatDetailViewController.makeFromStoryboard()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - StoryboardInitializable

extension ChatOverviewViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> ChatOverviewViewController {
        return StoryboardScene.Main.chatOverviewViewController.instantiate()
    }
}
