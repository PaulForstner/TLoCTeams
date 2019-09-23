//
//  ChatDataSource.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class ChatDataSource: NSObject {
    
    // MARK: - Constants
    
    let cellIdentifier = Constants.CellIdentifier.messageCell
    
    
    // MARK: - Typealias
    
    typealias ModelType = Message
    typealias DidSelectHandler = (_ item: ModelType) -> Void
    typealias UpdateHandler = () -> Void
    
    // MARK: - Properties - Handler
    
    private var didSelectHandler: DidSelectHandler
    private var updateHandler: UpdateHandler
    
    // MARK: - Properties
    
    private var dataSource = [ModelType]() {
        didSet {
            updateHandler()
        }
    }
    
    // MAKR: - Public
    
    func configure(tableView: UITableView) {
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    func set(_ dataSource: [ModelType]) {
        self.dataSource = dataSource
    }
    
    func append(_ item: ModelType) {
        dataSource.append(item)
    }
    
    // MARK: - Initializer
    
    init(didSelectHandler: @escaping DidSelectHandler, updateHandler: @escaping UpdateHandler) {
        
        self.didSelectHandler = didSelectHandler
        self.updateHandler = updateHandler
    }
}

// MARK: - UITableViewDataSource

extension ChatDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: dataSource.item(at: indexPath.row))
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChatDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = dataSource.item(at: indexPath.row) else {
            return
        }
        didSelectHandler(item)
    }
}
