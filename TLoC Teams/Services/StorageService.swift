//
//  StorageService.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 05.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import Foundation
import Firebase

class StorageService: NSObject {
    
    // MARK: - Enum
    
    public enum ImageType {
        
        case profileImage
        case eventImage
        case groupImage
        
        var path: String {
            switch self {
            case .profileImage: return "profile/"
            case .eventImage: return "event/"
            case .groupImage: return "group/"
            }
        }
    }
    
    // MARK: - Typealias
    
    typealias UrlCompletion = (URL?) -> Void
    
    // MARK: - Properties
    
    private static let imagesReference = Storage.storage().reference().child("images")
    
    // MARK: - Public
    
    class func uploadImage(_ image: UIImage, path: String, type: ImageType, completion: UrlCompletion?) {
        
        let imageReference = imagesReference.child("\(type.path)\(path)")

        guard let data = StorageService.getData(from: image) else {
            completion?(nil)
            return
        }
        
        imageReference.putData(data, metadata: nil) { (metadata, error) in
            
            guard error == nil else {
                completion?(nil)
                return
            }
            
            imageReference.downloadURL { (url, error) in
                completion?(url)
            }
        }
    }
    
    // MARK: - Helper
    
    private class func getData(from image: UIImage) -> Data? {
        
        if let data = image.pngData() {
            return data
        } else if let data = image.jpegData(compressionQuality: 0.4) {
            return data
        } else {
            return nil
        }
    }
}
