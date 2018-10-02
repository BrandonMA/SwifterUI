//
//  SFSingleChat.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 09/09/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSingleChat: SFChat {
    
    // MARK: - Instance Properties
    
    open override var imageURL: String? {
        get {
            return contact?.profilePictureURL
        } set {
            contact?.profilePictureURL = newValue
        }
    }
    
    open weak var contact: SFUser?
    
    // MARK: - Initialiers
    
    @discardableResult
    public init(identifier: String = UUID().uuidString, currentUser: SFUser, contact: SFUser, messages: [SFMessage] = [], modificationDate: Date = Date()) {
        self.contact = contact
        super.init(identifier: identifier, currentUser: currentUser, users: [], messages: messages, name: "\(contact.name) \(contact.lastName)", modificationDate: modificationDate)
        addNew(userIdentifier: contact.identifier)
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}








