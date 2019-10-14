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
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configure(tableView: tableView)
        setupDatabase()
        setupUI()
    }
    
    deinit {
        chatsReference?.removeAllObservers()
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
        
        chatsReference?.observe(.childAdded) { [weak self] (snapshot: DataSnapshot) in
            
            guard let chat = MappingHelper.mapChat(from: snapshot) else {
                return
            }
            
            self?.dataSource.append(chat)
        }
        
        chatsReference?.observe(.childRemoved) { [weak self] (snapshot: DataSnapshot) in
            
            self?.dataSource.remove(snapshot.key)
        }

        chatsReference?.observe(.childChanged) { [weak self] (snapshot: DataSnapshot) in
            
            guard let chat = MappingHelper.mapChat(from: snapshot) else {
                return
            }
            self?.dataSource.update(chat)
        }
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
