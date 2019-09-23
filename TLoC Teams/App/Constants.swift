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
    
    // MARK: - MessageFields
    
    struct UserFields {
        
        static let name = "name"
    }
    
    // MARK: - MessageFields
    
    struct ChatFields {
        
        static let name = "name"
        static let id = "id"
        static let messages = "messages"
        static let members = "members"
    }
    
    // MARK: - MessageFields
    
    struct MessageFields {
        
        static let name = "name"
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
        static let messageCell = "MessageTableViewCell"
    }
}

struct Alerts {
    
    static let DismissAlert = "Dismiss"
    static let ErrorTitle = "Error occured!"
    static let ErrorMessage = "Something went wrong please try again or restart the app."
    static let WrongInputTitle = "Wrong Input!"
    static let WrongInputMessage = "The input is wrong, please try again."
    static let WrongCredentialMessage = "The credentials are wrong, please try again."
    static let WrongUrlTitle = "Wrong URL!"
    static let WrongUrlMessage = "The url could not be opend."
    static let NoUrlMessage = "The input is no valid url."
    static let NoLocationFoundTitle = "No location found"
    static let NoLocationFoundMessage = "We could not find any location to your input, please try again."
    static let AddErrorMessage = "Could not add location."
    static let LogoutErrorTitle = "Could not log out."
}

