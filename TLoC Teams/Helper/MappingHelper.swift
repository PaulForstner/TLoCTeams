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
    
    class func mapMessage(from dic: Any?) -> Message? {
        
        guard let dic = dic as? [String: String] else {
            return nil
        }
        
        let name = dic[Constants.MessageFields.name] ?? ""
        let text = dic[Constants.MessageFields.text] ?? ""
        let id = dic[Constants.MessageFields.id] ?? ""
        
        return Message(name: name, id: id, text: text)
    }
    
    class func mapMessages(from messageDic: Any?) -> [Message] {
        
        guard let messageDic = messageDic as? [[String: String]] else {
            return []
        }
        
        var messages = [Message]()
        
        for dic in messageDic {
            
            guard let message = MappingHelper.mapMessage(from: dic) else {
                continue
            }
            messages.append(message)
        }
        
        return messages
    }
    
    class func mapChat(from dic: Any?, id: String) -> Chat? {
        
        guard let dic = dic as? [String: Any] else {
            return nil
        }
        
        let name = dic[Constants.ChatFields.name] as? String ?? ""
        let messagesDic = dic[Constants.ChatFields.messages] as? [[String: String]]
        let messages = MappingHelper.mapMessages(from: messagesDic)
        let members = dic[Constants.ChatFields.members] as? [Member] ?? []
        return Chat(name: name, id: id, messages: messages, members: members)
    }
    
    class func mapMember(from dic: Any?) -> Member? {
        
        guard let dic = dic as? [String: Any] else {
            return nil
        }
        
        let name = dic[Constants.MemberFields.name] as? String ?? ""
        let id = dic[Constants.MemberFields.id] as? String ?? ""
        
        return Member(name: name, id: id)
    }
    
    class func mapMembers(from memberDic: Any?) -> [Member] {
        
        guard let memberDic = memberDic as? [[String: Any]] else {
            return []
        }
        
        var members = [Member]()
        
        for dic in memberDic {
            
            guard let member = MappingHelper.mapMember(from: dic) else {
                continue
            }
            members.append(member)
        }
        
        return members
    }
}
