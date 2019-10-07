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
    
    private func uploadImage(_ image: UIImage) {
        
        let storageRef = Storage.storage().reference()
        let mountainsRef = storageRef.child("mountains.jpg")
        let mountainImagesRef = storageRef.child("images/mountains.jpg")
        
        let data = Data()
        let riversRef = storageRef.child("images/rivers.jpg")
        
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            
            let size = metadata.size
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
            }
        }
    }
    
    
//    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
//        let ref = Storage.storage().reference(forURL: url.absoluteString)
//        let megaByte = Int64(1 * 1024 * 1024)
//
//        ref.getData(maxSize: megaByte) { data, error in
//            guard let imageData = data else {
//                completion(nil)
//                return
//            }
//
//            completion(UIImage(data: imageData))
//        }
//    }
//
//    private func uploadImage(_ image: UIImage, to channel: Channel, completion: @escaping (URL?) -> Void) {
//        guard let channelID = channel.id else {
//            completion(nil)
//            return
//        }
//
//        guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
//            completion(nil)
//            return
//        }
//
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
//        storage.child(channelID).child(imageName).putData(data, metadata: metadata) { meta, error in
//            completion(meta?.downloadURL())
//        }
//    }
}
