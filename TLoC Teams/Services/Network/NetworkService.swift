//
//  NetworkService.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 12.09.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService: NSObject {
    
    class func request<T: Decodable, U: EndpointRouter>(router: U, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) -> URLSessionDataTask? {
        
        guard let urlRequest = router.urlRequest else {
            return nil
        }
        
//        Alamofire.re
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(T.self, from: data) as? Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
        return task
    }
}


//
//  NetworkService.swift
//  TestTask
//
//  Created by Paul Forstner on 18.03.19.
//  Copyright © 2019 APPSfactory GmbH. All rights reserved.
//
//
//import Alamofire
//
//class NetworkService: ResponseValidation {
//
//    // MARK: - Typealias
//
//    typealias SearchArtistServiceCompletion = ([Artist]) -> Void
//    typealias AlbumsServiceCompletion = ([Album]) -> Void
//    typealias AlbumTracksServiceCompletion = ([Track]) -> Void
//    typealias AlbumImageServiceCompletion = (UIImage) -> Void
//    typealias ErrorHandler = (String) -> Void
//
//    // MARK: - Public
//
//    class func searchArtist(artistName: String, successHandler: @escaping SearchArtistServiceCompletion, errorHandler: @escaping ErrorHandler) {
//
//        Alamofire.request(NetworkRouter.API.search(artistName: artistName))
//            .validate { (_, response, _) -> Request.ValidationResult in
//                return NetworkService.checkValidation(String(describing: self), response: response)
//            }.responseJSON { response in
//
//                switch response.result {
//                case .failure(let error):
//
//                    errorHandler(error as? String ?? "Error")
//                case .success:
//
//                    guard let value = response.result.value as? [String: Any],
//                        let results = value["results"] as? [String: Any],
//                        let artistmatches = results["artistmatches"] as? [String: Any],
//                        let artists = artistmatches["artist"] as? [[String: Any]] else {
//                            errorHandler("Error while fetching tags: \(String(describing: response.result.error))")
//                            return
//                    }
//
//                    guard let decodedArtists = decodeResponse([Artist].self, obj: artists) else {
//                        errorHandler("Unable to decode artists")
//                        return
//                    }
//
//                    successHandler(decodedArtists)
//                }
//        }
//    }
//
//    class func getAlbumsFromArtist(artistName: String, successHandler: @escaping AlbumsServiceCompletion, errorHandler: @escaping ErrorHandler) {
//        Alamofire.request(NetworkRouter.API.topAlbums(artistName: artistName))
//            .validate { (_, response, _) -> Request.ValidationResult in
//                return NetworkService.checkValidation(String(describing: self), response: response)
//            }.responseJSON { response in
//
//                switch response.result {
//                case .failure(let error):
//
//                    errorHandler(error as? String ?? "Error")
//                case .success:
//
//                    guard let value = response.result.value as? [String: Any],
//                        let topalbums = value["topalbums"] as? [String: Any],
//                        let albums = topalbums["album"] as? [[String: Any]] else {
//                            errorHandler("Error while fetching tags: \(String(describing: response.result.error))")
//                            return
//                    }
//
//                    guard let decodedAlbums = decodeResponse([Album].self, obj: albums) else {
//                        errorHandler("Unable to decode albums")
//                        return
//                    }
//
//                    successHandler(decodedAlbums)
//                }
//        }
//    }
//
//    class func getAlbumTracks(album: Album, successHandler: @escaping AlbumTracksServiceCompletion, errorHandler: @escaping ErrorHandler) {
//        Alamofire.request(NetworkRouter.API.albumInfo(artistName: album.artist.name, albumName: album.name))
//            .validate { (_, response, _) -> Request.ValidationResult in
//                return NetworkService.checkValidation(String(describing: self), response: response)
//            }.responseJSON { response in
//
//                switch response.result {
//                case .failure(let error):
//
//                    errorHandler(error as? String ?? "Error")
//                case .success:
//
//                    guard let value = response.result.value as? [String: Any],
//                        let album = value["album"] as? [String: Any],
//                        let tracks = album["tracks"] as? [String: Any],
//                        let track = tracks["track"] as? [[String: Any]] else {
//                            errorHandler("Error while fetching tags: \(String(describing: response.result.error))")
//                            return
//                    }
//
//                    guard let decodedTracks = decodeResponse([Track].self, obj: track) else {
//                        errorHandler("Unable to decode tracks")
//                        return
//                    }
//
//                    successHandler(decodedTracks)
//                }
//        }
//    }
//
//    // MARK: - Private
//
//    class private func decodeResponse<T: Decodable>(_ type: T.Type, obj: Any) -> T? {
//
//        do {
//            let jsonData = try? JSONSerialization.data(withJSONObject: obj)
//            let object = try JSONDecoder().decode(T.self, from: jsonData!)
//            return object
//        } catch {
//            return nil
//        }
//    }
//}
//
//// MARK: - ResponseValidation
//
//protocol ResponseValidation {
//
//    static func checkValidation(_ serviceString: String, response: HTTPURLResponse) -> Request.ValidationResult
//}
//
//extension ResponseValidation {
//
//    static func checkValidation(_ serviceString: String, response: HTTPURLResponse) -> Request.ValidationResult {
//
//        switch response.statusCode {
//        case 200..<400: return .success
//        default: return .failure(NSError(domain: "api.error: \(serviceString)", code: response.statusCode, userInfo: nil))
//        }
//    }
//}
