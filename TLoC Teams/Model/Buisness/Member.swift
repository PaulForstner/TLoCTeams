//
//  Member.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 18.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation

struct Member {
    
    let name: String
    let id: String
}

extension Member: DatabaseRepresantable {
    
    var dictionary: [String : Any] {
        return [
            Constants.MemberFields.name: name
        ]
    }
}
