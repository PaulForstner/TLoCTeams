//
//  Message.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 17.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation

struct Message {
    
    let date: String
    let sender: String
    let senderId: String
    let id: String
    let text: String
}

extension Message: DatabaseRepresantable {
    
    var dictionary: [String : Any] {
        return [
            Constants.MessageFields.date: date,
            Constants.MessageFields.sender: sender,
            Constants.MessageFields.senderId: senderId,
            Constants.MessageFields.text: text
        ]
    }
}
