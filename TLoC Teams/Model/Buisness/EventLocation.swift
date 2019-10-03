//
//  EventLocation.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 29.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation
import CoreLocation

struct EventLocation {
    
    let name: String
    let long: Double
    let lat: Double
}

extension EventLocation {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
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
