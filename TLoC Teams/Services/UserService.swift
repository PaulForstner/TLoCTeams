//
//  UserService.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 24.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    // MARK: - Typealias
    
    typealias CompletionHandler = (_ error: Error?) -> Void
    typealias SuccessHandler = (Bool) -> Void
    
    // MARK: - Properties
    
    private static let db = Firestore.firestore()
    
    // MARK: - Deinit
    
    deinit {
        
    }
    
    static func createUser(with email: String, username: String, password: String, completion: CompletionHandler?) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            completion?(error)
            guard let id = result?.user.uid else {
                return
            }
            let data = [Constants.UserFields.name: username]
            db.collection("users").addDocument(data: [id: data], completion: { (error) in
                
                if let e = error {
                    print("Error saving channel: \(e.localizedDescription)")
                }
            })
        }
    }
    
    static func login(with email: String, password: String, completion: CompletionHandler?) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            completion?(error)
        }
    }
    
    static func logout(completion: SuccessHandler?) {
        
        do {
            try Auth.auth().signOut()
            currentUser = nil
            completion?(true)
        } catch {
            completion?(false)
        }
    }
    
    static func sendPasswordReset(to email: String, completion: CompletionHandler?) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion?(error)
        }
    }
}
