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
    
    private var _imageURL: String?
    open override var imageURL: String? {
        get { return _imageURL }
        set { _imageURL = newValue }
    }
    
    // MARK: - Initialiers
    
    @discardableResult
    public init(identifier: String = UUID().uuidString, currentUser: SFUser, users: [SFUser], messages: [SFMessage] = [], name: String, modificationDate: Date = Date(), imageURL: String? = nil, image: UIImage? = nil) {
        super.init(identifier: identifier, currentUser: currentUser, users: [], messages: messages, name: name, modificationDate: modificationDate)
        self.imageURL = imageURL
        self.image = image
        users.forEach({ self.addNew(user: $0) })
    }
    
    // MARK: - Instance Methods
    
    open func addNew(user: SFUser) {
        
        if !users.contains(user.identifier) {
            users.append(user.identifier)
        }
        
        if !user.chats.contains(self) {
            user.chats.append(self)
        }
    }
}
