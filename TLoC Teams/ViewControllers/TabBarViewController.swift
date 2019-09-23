//
//  TabBarViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 21.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController {

    

}

// MARK: - StoryboardInitializable

extension TabBarViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> TabBarViewController {
        return StoryboardScene.Main.tabBarController.instantiate()
    }
}
