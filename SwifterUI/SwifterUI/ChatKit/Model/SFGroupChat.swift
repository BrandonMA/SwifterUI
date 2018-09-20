//
//  SFGroupChat.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 09/09/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFGroupChat: SFChat {
    
    // MARK: - Instance Properties
    
    // MARK: - Initialiers
    
    @discardableResult
    public init(identifier: String = UUID().uuidString, currentUser: SFUser, users: [SFUser], messages: [SFMessage] = [], name: String, modificationDate: Date = Date(), imageURL: String) {
        super.init(identifier: identifier, currentUser: currentUser, users: [], messages: messages, name: name, modificationDate: modificationDate)
        self.imageURL = imageURL
        users.forEach({ self.addNew(user: $0) })
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    // MARK: - Instance Methods
    
    open func addNew(user: SFUser) {
        
        if !users.contains(user.identifier) {
            users.append(user.identifier)
        }
        
//        if !user.chats.contains(self) {
//            user.chats.append(self)
//        }
    }
}
