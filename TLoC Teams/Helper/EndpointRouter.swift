//
//  EndpointRouter.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

enum HTTPMethodType: String {
    
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

protocol EndpointRouter {
    
    var baseURL: String { get }
    var method: HTTPMethodType { get }
    var path: String { get }
    var parameters: [String: String]? { get }
    var httpHeaders: [String: String]? { get }
    var bodyParameters: [String: Any]? { get }
}
