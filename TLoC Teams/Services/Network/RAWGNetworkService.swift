//
//  RAWGNetworkService.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 02.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation

class RAWGNetworkService: NSObject {
    
    typealias GamesCompletion = ([Game], Error?) -> Void
    
    class func search(game: String, completion: @escaping GamesCompletion) {

        let router = RAWGEndpointRouter.search(game: game)
        
        _ = NetworkService.request(router: router, responseType: RAWGResponse.self) { (result, error) in
            
            guard let gamesResponse = result?.results else {
                completion([], error)
                return
            }
            
            var games = [Game]()
            for game in gamesResponse {
                games.append(Game(name: game.name, imageUrl: game.imageUrl))
            }
            completion(games, nil)
        }
    }
}
