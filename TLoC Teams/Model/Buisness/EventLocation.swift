//
//  EventLocation.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 29.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation

struct EventLocation {
    
    let name: String
    let long: String
    let lat: String
}

extension EventLocation: DatabaseRepresantable {
    
    var dictionary: [String : Any] {
        return [
            Constants.LocationFields.name: name,
            Constants.LocationFields.long: long,
            Constants.LocationFields.lat: lat
        ]
    }
}
