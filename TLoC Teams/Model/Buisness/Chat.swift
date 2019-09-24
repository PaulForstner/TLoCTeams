//
//  Chat.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 18.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation

struct Chat {
    
    let name: String
    let id: String
    let messages: [Message]
    let members: [Member]
}

extension Chat: DatabaseRepresantable {
    
    var dictionary: [String : Any] {
        return [
            Constants.ChatFields.name: name,
            Constants.ChatFields.messages: messages,
            Constants.ChatFields.members: members
        ]
    }
}
