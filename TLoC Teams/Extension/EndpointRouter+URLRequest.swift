//
//  EndpointRouter+URLRequest.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

extension EndpointRouter {
    
    var urlRequest: URLRequest? {
        
        guard let url = URL(string: baseURL) else {
            return nil
        }
        
        var urlRequest          = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod   = method.rawValue.uppercased()
        
        if let parameters = parameters {
            
            var queryItems = [URLQueryItem]()
            for parameter in parameters {
                queryItems.append(URLQueryItem(name: parameter.key, value: parameter.value))
            }
            
            if let url = urlRequest.url {
                
                var newURL: URLComponents? = URLComponents(url: url, resolvingAgainstBaseURL: false)
                newURL?.queryItems = queryItems
                urlRequest.url = newURL?.url
            }
        }
        
        if let headers = httpHeaders {
            
            for (key, value) in headers where urlRequest.allHTTPHeaderFields?[key] == nil {
                
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = bodyParameters {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
        
        return urlRequest
    }
}
