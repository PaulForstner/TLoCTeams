//
//  AppDelegate.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupAppearance()
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        Firestore.firestore().settings.isPersistenceEnabled = true
        
        if Auth.auth().currentUser != nil {
            setTabBarToRoot()
        }
        
        return true
    }
    
    // MARK: - SetupAppearance
    
    private func setupAppearance() {
        
        window?.backgroundColor = .white
        
        // NavigationBar
        UINavigationBar.appearance().tintColor = ColorName.green.color
        
        // TabBar
        UITabBar.appearance().tintColor = ColorName.green.color
    }
    
    // MARK: - SetRootViewController
    
    func setLoginToRoot() {
        
        let vc = StoryboardScene.Main.loginNavigationController.instantiate()
        window?.rootViewController = vc
    }
    
    func setTabBarToRoot() {
        
        let vc = TabBarViewController.makeFromStoryboard()
        window?.rootViewController = vc
    }
}
