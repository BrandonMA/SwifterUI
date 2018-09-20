//
//  SFChatUser.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/28/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
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

open class SFUser: Hashable, Codable {
    
    public enum CodingKeys: String, CodingKey {
        case identifier
        case name
        case lastName
        case profilePictureURL
    }
    
    // MARK: - Static Methods
    
    public static func == (lhs: SFUser, rhs: SFUser) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.name == rhs.name && lhs.lastName == rhs.lastName && lhs.profilePictureURL == rhs.profilePictureURL
    }
    
    // MARK: - Instance Properties
    
    open var identifier: String
    open var name: String
    open var lastName: String
    open var profilePictureURL: String?
    
    open var hashValue: Int { return identifier.hashValue ^ name.hashValue ^ lastName.hashValue }
    public final weak var contactsDelegate: SFContactsDelegate?
    
    open var contacts: [SFUser] = [] {
        didSet { contactsDelegate?.performFullContactsUpdate() }
    }
    
    open var chatsManager = SFDataManager<SFChat>()
    
    // MARK: - Initializers
    
    public init(identifier: String = UUID().uuidString, name: String, lastName: String, profilePictureURL: String? = nil) {
        self.identifier = identifier
        self.name = name
        self.lastName = lastName
        self.profilePictureURL = profilePictureURL
    }
    
    public required init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try data.decode(String.self, forKey: CodingKeys.identifier)
        name = try data.decode(String.self, forKey: CodingKeys.name)
        lastName = try data.decode(String.self, forKey: CodingKeys.lastName)
        profilePictureURL = try data.decode(String?.self, forKey: CodingKeys.profilePictureURL)
    }
    
    // MARK: - Contacts
    
    // TODO: addNew(chat: SFChat) - Insert it in the correct place, do not use ordered(). Remove chat ability to add itself.
    // TODO: addNew(chats: [SFChat]) - Use ordered.
    // TODO: addNew(contact: SFUser) - Insert it in the correct place, do not use ordered().
    // TODO: addNew(contacts: [SFUser) - Use ordered.
    
    open func addNewContact(_ contact: SFUser) {
        if !contacts.contains(where: { $0.identifier == contact.identifier}) && !contact.contacts.contains(where: { $0.identifier == identifier}) && contact.identifier != identifier {
            contacts.append(contact)
            contact.contacts.append(self)
        }
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: CodingKeys.identifier)
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(lastName, forKey: CodingKeys.lastName)
        try container.encode(profilePictureURL, forKey: CodingKeys.profilePictureURL)
    }
    
}

public extension Array where Element: SFDataSection<SFUser> {
    
    public mutating func sortByInitial() {
        sort(by: { return $0.identifier < $1.identifier }) // Each identifier is a letter in the alphabet
    }
    
    public mutating func sortByLastname() {
        forEach { (section) in
            section.content.sort(by: { return $0.lastName < $1.lastName })
        }
    }
}

public extension Array where Element: SFUser {
    
    public func filter(by name: String) -> [SFUser] {
        return self.filter({ "\($0.name) \($0.lastName)".lowercased().contains(name.lowercased()) })
    }
    
    public func createDataSections() -> [SFDataSection<SFUser>] {
                
        var sections: [SFDataSection<SFUser>] = []
        
        for contact in self {
            
            if let index = sections.index(where: { $0.identifier.contains(contact.name.uppercased().first!) /* Use the initial as identifier */ }) {
                sections[index].content.append(contact)
            } else {
                let section = SFDataSection<SFUser>(content: [contact], identifier: "\(contact.name.uppercased().first!)")
                sections.append(section)
            }
        }
        
        return sections
    }
    
    public func ordered() -> [SFDataSection<SFUser>] {
        var sections = createDataSections()
        sections.sortByInitial()
        sections.sortByLastname()
        return sections
    }
    
}
