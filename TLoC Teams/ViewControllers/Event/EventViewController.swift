//
//  EventViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

final class EventViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    
    // MARK: - Properties
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Events"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateEvent))
        navigationItem.rightBarButtonItem = addButton
        
        setupUI()
        setupDatabase()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
    }
    
    private func setupDatabase() {
        
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
