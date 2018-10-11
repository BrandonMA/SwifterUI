//
//  SFChatUser.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/28/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import Kingfisher

public enum SFUserNotification: String {
    case deleted
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
        return lhs.identifier == rhs.identifier &&
            lhs.name == rhs.name &&
            lhs.lastName == rhs.lastName &&
            lhs.profilePictureURL == rhs.profilePictureURL
    }
    
    // MARK: - Instance Properties
    
    open var identifier: String
    open var name: String
    open var lastName: String
    open var profilePictureURL: String?
    
    open var hashValue: Int {
        return identifier.hashValue ^ name.hashValue ^ lastName.hashValue
    }
    
    open var contactsManager = SFDataManager<SFUser>()
    
    open var chatsManager = SFDataManager<SFChat>()
    
    // MARK: - Initializers
    
    public init(identifier: String = UUID().uuidString,
                name: String,
                lastName: String,
                profilePictureURL: String? = nil) {
        
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
    
    // MARK: - Instance Methods
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: CodingKeys.identifier)
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(lastName, forKey: CodingKeys.lastName)
        try container.encode(profilePictureURL, forKey: CodingKeys.profilePictureURL)
    }
        
    open func addNew(chat: SFChat) {
        if !chatsManager.contains(chat) {
            chatsManager.insertItem(chat, at: IndexPath(item: 0, section: 0))
        }
    }
    
    open func addNew(contact: SFUser) {
        
        if contactsManager.contains(contact) == false &&
            contact.contactsManager.contains(self) == false &&
            contact.identifier != identifier {
            
            if let sectionIndex = contactsManager.index(where: {
                $0.identifier.contains(contact.name.uppercased().first!)
            }) {
                for (index, user) in contactsManager[sectionIndex].enumerated() {
                    if user.lastName > contact.lastName {
                        contactsManager.insertItem(contact, at: IndexPath(item: index, section: sectionIndex))
                        break
                    }
                }
            } else {
                
                let newSection = SFDataSection<SFUser>(content: [contact], identifier: "\(contact.name.uppercased().first!)")
                
                if contactsManager.isEmpty {
                    contactsManager.insertSection(newSection)
                } else {
                    for (index, section) in contactsManager.enumerated() {
                        if section.identifier > newSection.identifier {
                            contactsManager.insertSection(newSection, at: index)
                            break
                        }
                    }
                }
            }
        }
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
    
    public func createDataSections() -> [SFDataSection<SFUser>] {
                
        var sections: [SFDataSection<SFUser>] = []
        
        for contact in self {
            
            if let index = sections.index(where: {
                $0.identifier.contains(contact.name.uppercased().first!)
            }) {
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
