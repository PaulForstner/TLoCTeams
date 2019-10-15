//
//  Constants.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 11.09.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: - NotificationKeys
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    
    // MARK: - UserFields
    
    struct UserFields {
        
        static let name = "name"
        static let imageUrl = "imageUrl"
    }
    
    // MARK: - EventFields
    
    struct EventFields {
        
        static let name = "name"
        static let id = "id"
        static let date = "date"
        static let imageUrl = "imageUrl"
        static let game = "game"
        static let location = "location"
        static let memberIds = "memberIds"
    }
    
    // MARK: - GameFields
    
    struct GameFields {
        
        static let name = "name"
        static let imageUrl = "imageUrl"
    }
    
    // MARK: - LocationFields
    
    struct LocationFields {
        
        static let name = "name"
        static let long = "long"
        static let lat = "lat"
    }
    
    // MARK: - ChatFields
    
    struct ChatFields {
        
        static let name = "name"
        static let id = "id"
        static let imageUrl = "imageUrl"
        static let messages = "messages"
    }
    
    // MARK: - MessageFields
    
    struct MessageFields {
        
        static let date = "date"
        static let sender = "sender"
        static let senderId = "senderId"
        static let id = "id"
        static let text = "text"
        static let imageUrl = "photoUrl"
    }
    
    // MARK: - MemberFields
    
    struct MemberFields {
        
        static let name = "name"
        static let id = "id"
    }
    
    // MARK: - CellIdentifier
    
    struct CellIdentifier {
        
        static let chatCell = "ChatTableViewCell"
        static let gameCell = "GameTableViewCell"
        static let messageCell = "MessageTableViewCell"
        static let outgoingMessageCell = "OutgoingMessageTableViewCell"
        static let eventCell = "EventTableViewCell"
    }
}

struct Alerts {
    
    static let Ok = "Ok"
    static let Cancel = "Cancel"
    static let DismissAlert = "Dismiss"
    static let ErrorTitle = "Error occured!"
    static let ErrorMessage = "Something went wrong please try again or restart the app."
    static let WrongInputTitle = "Wrong Input!"
    static let WrongCredentialMessage = "The credentials are wrong, please try again."
    static let NoLocationFoundTitle = "No location found"
    static let NoLocationFoundMessage = "We could not find any location to your input, please try again."
    static let DeleteAlertTitle = "Delete Account"
    static let DeleteAlertDescription = "Are you sure you want to delete your account?"
    static let LogoutErrorDescription = "Could not log out."
    static let SuccessTitle = "Success!"
    static let SuccessfullySendForgotPassword = "An email to reset your password was send to you."
}

