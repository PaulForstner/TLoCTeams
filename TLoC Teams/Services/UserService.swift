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
    typealias UserCompletionHandler = (_ user: User?) -> Void
    typealias SuccessHandler = (Bool) -> Void
    
    // MARK: - Properties
    
    private static let db = Firestore.firestore()
    
    // MARK: - User
    
    static func getCurrentUser(completion: @escaping UserCompletionHandler) {
        
        guard let userId = Auth.auth().currentUser?.uid, let email = Auth.auth().currentUser?.email else {
            completion(nil)
            return
        }
        
        db.collection("users").document(userId).getDocument { (snapShot, error) in
            
            guard let snapShot = snapShot else {
                completion(nil)
                return
            }
            
            var user = MappingHelper.mapUser(from: snapShot)
            user?.email = email
            completion(user)
        }
    }
    
    static func setCurrentUser(_ user: User, completion: @escaping CompletionHandler) {
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        if user.email != currentUser.email {
            currentUser.updateEmail(to: user.email) { (error) in
                
                db.collection("users").document(currentUser.uid).setData(user.dictionary)
                completion(error)
            }
        } else {
            db.collection("users").document(currentUser.uid).setData(user.dictionary)
            completion(nil)
        }
    }
    
    static func createUser(with email: String, username: String, password: String, completion: CompletionHandler?) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            completion?(error)
            guard let id = result?.user.uid else {
                return
            }
            let data = [Constants.UserFields.name: username,
                        Constants.UserFields.imageUrl: ""]
            db.collection("users").document(id).setData(data)
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
    
    static func deleteUser(completion: CompletionHandler?) {
        
        Auth.auth().currentUser?.delete(completion: { (error) in
            
            completion?(error)
        })
    }
}
