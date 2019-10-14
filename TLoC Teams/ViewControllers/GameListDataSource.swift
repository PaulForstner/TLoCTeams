//
//  GameListDataSource.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 02.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class GameListDataSource: NSObject {
    
    // MARK: - Constants
    
    private let cellIdentifier = Constants.CellIdentifier.gameCell
    
    // MARK: - Typealias
    
    typealias ModelType = Game
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
    
    // MARK: - Initializer
    
    init(didSelectHandler: @escaping DidSelectHandler, updateHandler: @escaping UpdateHandler) {
        
        self.didSelectHandler = didSelectHandler
        self.updateHandler = updateHandler
    }
}

// MARK: - UITableViewDataSource

extension GameListDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GameTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: dataSource.item(at: indexPath.row))
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GameListDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = dataSource.item(at: indexPath.row) else {
            return
        }
        didSelectHandler(item)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? ImageLoadable else {
            return
        }
        cell.cancel()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? ImageLoadable else {
            return
        }
        let url = URL(string: dataSource.item(at: indexPath.row)?.imageUrl ?? "")
        cell.loadImage(url: url, placeholderImage: Asset.monitor.image)
    }
}
