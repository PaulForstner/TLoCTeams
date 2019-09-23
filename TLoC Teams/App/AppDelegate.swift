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
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }
    
    // MARK: - SetRootViewController
    
    func setLoginToRoot() {
        
        let vc = LoginViewController.makeFromStoryboard()
        window?.rootViewController = vc
    }
    
    func setTabBarToRoot() {
        
        let vc = TabBarViewController.makeFromStoryboard()
        window?.rootViewController = vc
    }
}
