//
//  ChatDataSource.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase

class ChatDataSource: NSObject {
    
    // MARK: - Constants
    
    let cellIdentifier = Constants.CellIdentifier.messageCell
    let outgoingCellIdentifier = Constants.CellIdentifier.outgoingMessageCell
    
    // MARK: - Typealias
    
    typealias ModelType = Message
    typealias AddMessageHandler = (_ index: Int) -> Void
    
    // MARK: - Properties - Handler
    
    private var addMessageHandler: AddMessageHandler
    
    // MARK: - Properties
    
    private var dataSource = [ModelType]()
    
    // MAKR: - Public
    
    func configure(tableView: UITableView) {
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(UINib(nibName: outgoingCellIdentifier, bundle: nil), forCellReuseIdentifier: outgoingCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
    
    func set(_ dataSource: [ModelType]) {
        self.dataSource = dataSource
    }
    
    func append(_ item: ModelType) {
        
        dataSource.append(item)
        addMessageHandler(dataSource.count - 1)
    }
    
    // MARK: - Initializer
    
    init(addMessageHandler: @escaping AddMessageHandler) {
        self.addMessageHandler = addMessageHandler
    }
}

// MARK: - UITableViewDataSource

extension ChatDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item = dataSource.item(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        if item.senderId == Auth.auth().currentUser?.uid {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: outgoingCellIdentifier, for: indexPath) as? OutgoingMessageTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: dataSource.item(at: indexPath.row))
            
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: dataSource.item(at: indexPath.row))
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ChatDataSource: UITableViewDelegate {
    
}
