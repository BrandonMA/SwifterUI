//
//  SFChatUser.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/28/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit
import Kingfisher

enum SFUserError: Error {
    case ProfilePictureDownload
}

public protocol SFContactsDelegate: class {
    func performFullContactsUpdate()
}

public protocol SFChatsDelegate: class {
    func performFullChatsUpdate()
}

open class SFUser: Hashable {
    
    // MARK: - Static Methods
    
    open static func == (lhs: SFUser, rhs: SFUser) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.name == rhs.name && lhs.lastName == rhs.lastName
    }
    
    // MARK: - Instance Properties
    
    open var identifier: String
    open var name: String
    open var lastName: String
    open var profilePictureURL: String?
    
    open var hashValue: Int { return identifier.hashValue }
    public final weak var contactsDelegate: SFContactsDelegate?
    public final weak var chatsDelegate: SFChatsDelegate?
    open var profilePicture: UIImage?
    
    open var contacts: [SFUser] = [] {
        didSet { contactsDelegate?.performFullContactsUpdate() }
    }
    
    open var chats: [SFChat] = [] {
        didSet {
            chatsDelegate?.performFullChatsUpdate()
        }
    }
    
    // MARK: - Initializers
    
    public init(identifier: String = UUID().uuidString, name: String, lastName: String, profilePictureURL: String? = nil) {
        self.identifier = identifier
        self.name = name
        self.lastName = lastName
        self.profilePictureURL = profilePictureURL
    }
    
    // MARK: - Contacts
    
    open func addNewContact(_ contact: SFUser) {
        if !contacts.contains(where: { $0.identifier == contact.identifier}) && !contact.contacts.contains(where: { $0.identifier == identifier}) && contact.identifier != identifier {
            contacts.append(contact)
            contact.contacts.append(self)
        }
    }
    
}

public extension Array where Element: SFUser {
    
    public func filter(by name: String) -> [SFUser] {
        return self.filter({ "\($0.name) \($0.lastName)".lowercased().contains(name.lowercased()) })
    }
    
    public func ordered() -> [SFDataSection<SFUser>] {
        
        var sections: [SFDataSection<SFUser>] = []
        
        for contact in self {
            
            if let index = sections.index(where: { $0.identifier.contains(contact.name.uppercased().first!) }) {
                sections[index].content.append(contact)
            } else {
                let section = SFDataSection<SFUser>(content: [contact], identifier: "\(contact.name.uppercased().first!)")
                sections.append(section)
            }
        }
        
        sections.sort(by: { (current, next) -> Bool in
            return current.identifier < next.identifier
        })
        
        for (index, var section) in sections.enumerated() {
            section.content.sort(by: { (current, next) -> Bool in
                return current.lastName < next.lastName
            })
            sections[index] = section
        }
        
        return sections
    }
    
}
