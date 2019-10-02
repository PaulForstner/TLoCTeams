//
//  Game.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 29.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation

struct Game {
    
    let name: String
    let imageUrl: String
}

extension Game: DatabaseRepresantable {
    
    var dictionary: [String : Any] {
        return [
            Constants.GameFields.name: name,
            Constants.GameFields.imageUrl: imageUrl
        ]
    }
}
