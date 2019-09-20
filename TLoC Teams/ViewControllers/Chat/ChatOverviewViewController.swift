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
        return ChatOverviewDataSource(didSelectHandler: { (item) in
            
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
        configureDatabase()
//        let vc = ChatViewController.makeFromStoryboard()
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureDatabase() {
        chatReference = Database.database().reference()
        
        chatHandler = chatReference?.child("rooms").observe(.childAdded) { [weak self] (snapshot: DataSnapshot) in
            
            guard let chat = MappingHelper.mapChat(from: snapshot.value),
                chat.members.contains(where: { $0.name == "myAccountName/ID" }) else {
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
}

// MARK: - StoryboardInitializable

extension ChatOverviewViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> ChatOverviewViewController {
        return StoryboardScene.Main.chatOverviewViewController.instantiate()
    }
}
