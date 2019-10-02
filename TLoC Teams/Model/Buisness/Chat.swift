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
    let imageUrl: String?
    let messages: [Message]
}

extension Chat: DatabaseRepresantable {
    
    var dictionary: [String : Any] {
        return [
            Constants.ChatFields.name: name,
            Constants.ChatFields.imageUrl: imageUrl as Any,
            Constants.ChatFields.messages: messages
        ]
    }
}
