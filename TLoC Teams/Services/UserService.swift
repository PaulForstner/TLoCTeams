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
    
    private static let db = Firestore.firestore()
    
    static var currentUser: User?
//    {
//
//        guard let userId = Auth.auth().currentUser?.uid else {
//            return nil
//        }
//
//        db.collection("users").document(userId).getDocument { (snapShot, error) in
//
//            guard let snapShot = snapShot else {
//                return
//            }
//
//            return MappingHelper.mapUser(from: snapShot)
//        }
//    }
    
    static func createUser(with email: String, username: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
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
    
    static func login(with email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
        }
    }
    
    private static func setupUserReference() {
        
    }
}
