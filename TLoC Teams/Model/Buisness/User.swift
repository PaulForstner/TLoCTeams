//
//  User.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 19.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation

struct User {
    
    var email: String
    let name: String
    let imageUrl: String
}

extension User: DatabaseRepresantable {
    
    var dictionary: [String : Any] {
        return [
            Constants.UserFields.name: name,
            Constants.UserFields.imageUrl: imageUrl
        ]
    }
}
