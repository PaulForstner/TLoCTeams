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
    
    // MARK: - Properties
    
    private var displayName = "Anonymous"
    private var ref: DatabaseReference!
    fileprivate var _refHandle: DatabaseHandle!
    private var messages: [DataSnapshot]! = []
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatabase()
        
        
        let data = [Constants.MessageFields.text: "test"]
        sendMessage(data: data)
    }
    
    deinit {
        ref.child("messages").removeObserver(withHandle: _refHandle)
        
        _refHandle = ref.child("messages").observe(.childAdded) { (snapshot: DataSnapshot)in
            self.messages.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .automatic)
            self.scrollToBottomMessage()
        }
    }
    
    // MARK: - Setup
    
    private func configureDatabase() {
        ref = Database.database().reference()
        
    }
    
    // MARK: - Helper
    
    private func sendMessage(data: [String: String]) {
        
        var mdata = data
        // add name to message and then data to firebase database
        mdata[Constants.MessageFields.name] = displayName
        ref.child("messages").childByAutoId().setValue(mdata)
    }
    
    private func scrollToBottomMessage() {
        if messages.count == 0 { return }
        let bottomMessageIndex = IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)
        tableView.scrollToRow(at: bottomMessageIndex, at: .bottom, animated: true)
    }
}

// MARK: - StoryboardInitializable

extension ChatViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> ChatViewController {
        return StoryboardScene.Main.chatViewController.instantiate()
    }
}
