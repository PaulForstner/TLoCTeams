//
//  Event.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 29.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation

struct Event {
    
    let name: String
    let id: String
    let date: String
    let imageUrl: String
    let game: Game?
    let location: EventLocation?
    let memberIds: [String]
}

extension Event: DatabaseRepresantable {
    
    var dictionary: [String : Any] {
        
        var dic: [String : Any] = [
            Constants.EventFields.name: name,
            Constants.EventFields.date: date,
            Constants.EventFields.imageUrl: imageUrl,
            Constants.EventFields.memberIds: memberIds
        ]
        
        if let game = game {
            dic[Constants.EventFields.game] = game.dictionary
        }
        
        if let location = location {
            dic[Constants.EventFields.location] = location.dictionary
        }
        
        return dic
    }
}
