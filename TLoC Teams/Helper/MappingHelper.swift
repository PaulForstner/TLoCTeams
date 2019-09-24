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
    
    class func mapUser(from snapShot: DataSnapshot) -> User? {
        
        guard let dic = snapShot.value as? [String: Any],
            let name = dic[Constants.UserFields.name] as? String else {
                return nil
        }
        
        return User(name: name, id: snapShot.key)
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
        
        return Chat(name: name, id: snapShot.key, messages: [], members: [])
    }
    
    // MARK: - Helper
    
    private class func mapMessage(from dic: [String: Any], id: String) -> Message? {
        
        guard let sender = dic[Constants.MessageFields.sender] as? String,
            let text = dic[Constants.MessageFields.text] as? String else {
                return nil
        }
        
        return Message(sender: sender, id: id, text: text)
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
