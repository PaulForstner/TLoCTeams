//
//  NetworkService.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import Alamofire

enum NetworkError: Error {
    case parsingError
}

class NetworkService: NSObject {
    
    class func request<T: Decodable, U: EndpointRouter>(router: U, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) -> URLSessionTask?  {
        
        guard let urlRequest = router.urlRequest else {
            return nil
        }
        
        let request = Alamofire.request(urlRequest).validate(statusCode: 200..<300).responseData { (response) in
            
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                if let result = try? decoder.decode(T.self, from: data) {
                    completion(result, nil)
                } else {
                    completion(nil, NetworkError.parsingError)
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
        
        return request.task
    }
}
