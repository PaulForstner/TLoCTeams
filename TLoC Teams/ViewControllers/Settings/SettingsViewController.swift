//
//  SettingsViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

// MARK: - StoryboardInitializable

extension SettingsViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> SettingsViewController {
        return StoryboardScene.Main.settingsViewController.instantiate()
    }
}
