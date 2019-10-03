//
//  RAWGEndpointRouter.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 02.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation

enum RAWGEndpointRouter: EndpointRouter {
    
    case search(game: String)
    
    var baseURL: String{
        return  "https://api.rawg.io/api/"
    }
    
    var method: HTTPMethodType{
        
        switch self {
        case .search: return .get
        }
    }
    
    var path: String{
        
        switch self {
        case .search: return "games"
        }
    }
    
    var parameters: [String : String]? {
        
        switch self {
        case .search(let game): return ["page_size": "10",
                                        "search": game]
        }
    }
    
    var httpHeaders: [String : String]? {
        
        switch self {
        case .search: return ["User-Agent": "TLoC Teams"]
        }
    }
    
    var bodyParameters: [String : Any]? {
        
        switch self {
        case .search: return nil
        }
    }
}
