//
//  GameResponse.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 02.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation

struct GameResponse: Codable {
    
    let name: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case imageUrl = "background_image"
    }
}
