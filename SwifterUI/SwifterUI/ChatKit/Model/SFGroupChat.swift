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
    public init(identifier: String = UUID().uuidString, currentUser: SFUser, users: [String], messages: [SFMessage] = [], name: String, modificationDate: Date = Date(), imageURL: String) {
        super.init(identifier: identifier, currentUser: currentUser, users: [], messages: messages, name: name, modificationDate: modificationDate)
        self.imageURL = imageURL
        users.forEach({ self.addNew(userIdentifier: $0) })
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}
