//
//  EventViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase

final class EventViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lazy
    
    private lazy var dataSource: EventDataSource = {
        return EventDataSource(didSelectHandler: { (event) in
            
        }, updateHandler: { [weak self] in
            self?.tableView.reloadData()
        })
    }()
    
    // MARK: - Properties
    
    private var eventsListener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Events"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateEvent))
        navigationItem.rightBarButtonItem = addButton
        
        setupDatabase()
        dataSource.configure(tableView: tableView)
    }
    
    deinit {
        eventsListener?.remove()
    }
    
    // MARK: - Setup
    
    private func setupDatabase() {
        
        eventsListener = db.collection("events").addSnapshotListener { querySnapshot, error in
        
            guard let snapshot = querySnapshot else {
                return
            }
    
            snapshot.documentChanges.forEach { [weak self] change in
                
                guard let event = MappingHelper.mapEvent(from: change.document) else {
                    return
                }
                
                switch change.type {
                case .added:    self?.dataSource.append(event)
                case .modified: self?.dataSource.update(event)
                case .removed:  self?.dataSource.remove(event)
                default:        break
                }
            }
        }
    }
    
    // MARK: - Helper
    
    @objc private func showCreateEvent() {
        
        let vc = CreateEventViewController.makeFromStoryboard()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - StoryboardInitializable

extension EventViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> EventViewController {
        return StoryboardScene.Main.eventViewController.instantiate()
    }
}
