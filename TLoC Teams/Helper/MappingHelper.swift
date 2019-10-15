//
//  MappingHelper.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 17.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase

class MappingHelper: NSObject {
    
    class func mapEvent(from snapShot: QueryDocumentSnapshot) -> Event? {
        
        let dic = snapShot.data()
        guard let name = dic[Constants.EventFields.name] as? String,
            let date = dic[Constants.EventFields.date] as? String,
            let imageUrl = dic[Constants.EventFields.imageUrl] as? String,
            let memberIds = dic[Constants.EventFields.memberIds] as? [String] else {
                return nil
        }
        
        let game = MappingHelper.mapGame(from: dic[Constants.EventFields.game] as? [String: Any] ?? [:])
        let location = MappingHelper.mapLocation(from: dic[Constants.EventFields.location] as? [String: Any] ?? [:])
        
        return Event(name: name, id: snapShot.documentID, date: date, imageUrl: imageUrl, game: game, location: location, memberIds: memberIds)
    }
    
    class func mapUser(from snapShot: DocumentSnapshot) -> User? {
        
        guard let dic = snapShot.data(),
            let name = dic[Constants.UserFields.name] as? String,
            let imageUrl = dic[Constants.UserFields.imageUrl] as? String else {
                return nil
        }
        
        return User(email: "", name: name, imageUrl: imageUrl)
    }
    
    class func mapMessage(from snapShot: DataSnapshot) -> Message? {
        
        guard let dic = snapShot.value as? [String: Any] else {
            return nil
        }
        
        return MappingHelper.mapMessage(from: dic, id: snapShot.key)
    }
    
    class func mapMember(from snapShot: DataSnapshot) -> Member? {
        
        guard let dic = snapShot.value as? [String: Any] else {
            return nil
        }
        
        let name = dic[Constants.MemberFields.name] as? String ?? ""
        let id = dic[Constants.MemberFields.id] as? String ?? ""
        
        return Member(name: name, id: id)
    }
    
    class func mapChat(from snapShot: DataSnapshot) -> Chat? {
        
        guard let dic = snapShot.value as? [String: Any],
            let name = dic[Constants.ChatFields.name] as? String else {
                return nil
        }
        let imageUrl = dic[Constants.ChatFields.imageUrl] as? String
        
        return Chat(name: name, id: snapShot.key, imageUrl: imageUrl)
    }
    
    // MARK: - Helper
    
    private class func mapGame(from dic: [String: Any]) -> Game? {
        
        guard let name = dic[Constants.GameFields.name] as? String,
            let imageUrl = dic[Constants.GameFields.imageUrl] as? String else {
                return nil
        }
        
        return Game(name: name, imageUrl: imageUrl)
    }
    
    private class func mapLocation(from dic: [String: Any]) -> EventLocation? {
        
        guard let name = dic[Constants.LocationFields.name] as? String,
            let long = dic[Constants.LocationFields.long] as? Double,
            let lat = dic[Constants.LocationFields.lat] as? Double else {
                return nil
        }
        
        return EventLocation(name: name, long: long, lat: lat)
    }
    
    private class func mapMessage(from dic: [String: Any], id: String) -> Message? {
        
        guard let sender = dic[Constants.MessageFields.sender] as? String,
            let senderId = dic[Constants.MessageFields.senderId] as? String,
            let date = dic[Constants.MessageFields.date] as? String,
            let text = dic[Constants.MessageFields.text] as? String else {
                return nil
        }
        
        return Message(date: date, sender: sender, senderId: senderId, id: id, text: text)
    }
    
    private class func mapMessages(from messagesDic: [String: [String: String]]) -> [Message] {
        
        var messages = [Message]()
        
        for dic in messagesDic {
            
            guard let message = MappingHelper.mapMessage(from: dic.value, id: dic.key) else {
                continue
            }
            messages.append(message)
        }
        
        return messages
    }
}
