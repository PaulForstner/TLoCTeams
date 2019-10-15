//
//  EventDetailDataSource.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 15.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

class EventDetailDataSource: NSObject {
    
    // MARK: - Struct
    
    public struct CellModel {
        
        let id: String
        let name: String
    }
    
    // MARK: - Typealias
    
    typealias UpdateHandler = (_ index: Int) -> Void
    
    // MARK: - Properties - Handler
    
    private var addHandler: UpdateHandler
    private var removeHandler: UpdateHandler
    
    // MARK: - Properties
    
    private var dataSource = [CellModel]()
    
    // MAKR: - Public
    
    func configure(tableView: UITableView) {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
    }
    
    func append(_ item: CellModel) {
        
        guard dataSource.first(where: { $0.id == item.id }) == nil else {
            return
        }
        
        dataSource.append(item)
        addHandler(dataSource.count - 1)
    }
    
    func removeItemWith(_ id: String) {
        
        guard let index = dataSource.firstIndex(where: {$0.id == id}) else {
            return
        }
        dataSource.remove(at: index)
        removeHandler(index)
    }
    
    // MARK: - Initializer
    
    init(addHandler: @escaping UpdateHandler, removeHandler: @escaping UpdateHandler) {
        
        self.addHandler = addHandler
        self.removeHandler = removeHandler
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension EventDetailDataSource: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = dataSource.item(at: indexPath.row)?.name ?? "Unkown"
        return cell
    }
}
