//
//  SFChat.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/28/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public enum SFChatNotification: String {
    case unreadMessagesUpdate
    case newMessage
    case deleted
}

open class SFChat: Hashable, Codable {
    
    public enum CodingKeys: String, CodingKey {
        case identifier
        case modificationDate
        case users
        case name
        case imageURL
    }
    
    // MARK: - Static Methods
    
    public static func == (lhs: SFChat, rhs: SFChat) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.name == rhs.name && lhs.imageURL == rhs.imageURL
    }
    
    // MARK: - Instance Properties
    
    open var identifier: String
    open var modificationDate: Date
    open var users: [String] = []
    open var name: String
    open var imageURL: String?
    
    open var hashValue: Int { return identifier.hashValue ^ modificationDate.hashValue ^ name.hashValue }
    open weak var currentUser: SFUser?
    open var unreadMessages = 0
    
    open var messagesManager = SFDataManager<SFMessage>()
    
    // MARK: - Initialiers
    
    public required init(identifier: String = UUID().uuidString, users: [String], messages: [SFMessage] = [], name: String, modificationDate: Date = Date()) {
        self.identifier = identifier
        self.modificationDate = modificationDate
        self.users = users
        self.name = name
        messagesManager.update(dataSections: messages.ordered())
        checkUnreadMessages()
    }
    
    public required init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try data.decode(String.self, forKey: CodingKeys.identifier)
        modificationDate = try data.decode(Date.self, forKey: CodingKeys.identifier)
        users = try data.decode(Array<String>.self, forKey: CodingKeys.users)
        name = try data.decode(String.self, forKey: CodingKeys.name)
        imageURL = try data.decode(String?.self, forKey: CodingKeys.imageURL)
    }
    
    // MARK: - Instance Methods
    
    open func addNew(userIdentifier: String) {
        if !users.contains(userIdentifier) {
            users.append(userIdentifier)
        }
    }
    
    private func getSender(for message: SFMessage) {
        if message.senderIdentifier == currentUser?.identifier {
            message.sender = currentUser
        } else if let user = currentUser?.contactsManager.flatData.first(where: { $0.identifier == message.senderIdentifier}) {
            message.sender = user
        }
    }
    
    open func addNew(message: SFMessage) {
        
        if !messagesManager.contains(item: message) {
            
            getSender(for: message)
            
            let messageDate = message.creationDate.string(with: "EEEE dd MMM yyyy")
            if let lastSection = messagesManager.last {
                if lastSection.identifier != messageDate {
                    let section = SFDataSection<SFMessage>(content: [message], identifier: messageDate)
                    messagesManager.insertSection(section)
                } else {
                    messagesManager.insertItem(message)
                }
            } else {
                let section = SFDataSection<SFMessage>(content: [message], identifier: messageDate)
                messagesManager.insertSection(section)
            }
            
            NotificationCenter.default.post(name: Notification.Name(SFChatNotification.newMessage.rawValue), object: nil, userInfo: ["SFChat": self])
            checkUnreadMessages()
        }
    }
        
    open func checkUnreadMessages() {
        
        guard let currentUser = currentUser else { return }
        
        unreadMessages = 0
        
        messagesManager.flatData.forEach {
            if !$0.read && $0.senderIdentifier != currentUser.identifier {
                unreadMessages += 1
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(SFChatNotification.unreadMessagesUpdate.rawValue), object: nil, userInfo: ["SFChat": self])
    }
    
    open func markMessagesAsRead() {
        
        guard let currentUser = currentUser else { return }
        
        messagesManager.flatData.forEach {
            if !$0.read && $0.senderIdentifier != currentUser.identifier {
                $0.read = true
            }
        }
        
        unreadMessages = 0
        
        NotificationCenter.default.post(name: Notification.Name(SFChatNotification.unreadMessagesUpdate.rawValue), object: nil, userInfo: ["SFChat": self])
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: CodingKeys.identifier)
        try container.encode(modificationDate, forKey: CodingKeys.modificationDate)
        try container.encode(users, forKey: CodingKeys.users)
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(imageURL, forKey: CodingKeys.imageURL)
    }
}

public extension Array where Element: SFDataSection<SFChat> {
    
    public mutating func sortByModificationTime() {
        forEach { (section) in
            section.content.sort { (current, next) -> Bool in
                return current.modificationDate > next.modificationDate
            }
        }
    }
}

public extension Array where Element: SFChat {
    
    public func createDataSections() -> [SFDataSection<SFChat>] {
        let section = SFDataSection<SFChat>(content: self)
        return [section]
    }
    
    public func ordered() -> [SFDataSection<SFChat>] {
        var sections = createDataSections()
        sections.sortByModificationTime()
        return sections
    }
    
}
