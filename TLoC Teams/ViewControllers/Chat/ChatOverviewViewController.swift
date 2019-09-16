//
//  ChatOverviewViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

final class ChatOverviewViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
}

// MARK: - StoryboardInitializable

extension ChatOverviewViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> ChatOverviewViewController {
        return StoryboardScene.Main.chatOverviewViewController.instantiate()
    }
}
