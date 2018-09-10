//
//  SFChat.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/28/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit

public enum SFChatNotification: String {
    case unreadMessagesUpdate
    case newMessageUpdate
    case multipleMessagesUpdate
}

open class SFChat: Hashable {
    
    // MARK: - Static Methods
    
    public static func == (lhs: SFChat, rhs: SFChat) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.modificationDate == rhs.modificationDate && lhs.users == rhs.users && lhs.name == rhs.name
    }
    
    // MARK: - Instance Properties
    
    open var identifier: String
    open var modificationDate: Date
    open var users: [String] = []
    open var name: String
    open var imageURL: String? { return nil }
    
    open var hashValue: Int { return identifier.hashValue }
    open unowned var currentUser: SFUser
    open var unreadMessages = 0
    open var image: UIImage?
    
    private var _messages: [SFMessage] = []
    open var messages: [SFMessage] {
        set(newValue) {
            
            let newMessages = newValue.count - _messages.count
            _messages = newValue
            
            if newMessages == 1 {
                 NotificationCenter.default.post(name: Notification.Name(SFChatNotification.newMessageUpdate.rawValue), object: nil, userInfo: ["SFChat": self])
            } else if newMessages > 1 {
                NotificationCenter.default.post(name: Notification.Name(SFChatNotification.multipleMessagesUpdate.rawValue), object: nil, userInfo: ["SFChat": self])
            }
            
            checkUnreadMessages()
                        
        } get {
            return _messages
        }
    }
    
    // MARK: - Initialiers
    
    public init(identifier: String = UUID().uuidString, currentUser: SFUser, users: [String], messages: [SFMessage] = [], name: String, modificationDate: Date = Date()) {
        self.identifier = identifier
        self.modificationDate = modificationDate
        self.currentUser = currentUser
        self.users = users
        self.name = name
        self.messages = messages
        self.users.append(currentUser.identifier)
        checkUnreadMessages()
        self.currentUser.chats.append(self)
    }
    
    // MARK: - Instance Methods
    
    func checkUnreadMessages() {
        
        unreadMessages = 0
        
        messages.forEach { (message) in
            if !message.read && message.senderIdentifier != currentUser.identifier {
                unreadMessages += 1
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(SFChatNotification.unreadMessagesUpdate.rawValue), object: nil, userInfo: ["SFChat": self])
    }
}

public extension Array where Element: SFChat {
    
    public func filter(by title: String) -> [SFChat] {
        return self.filter({ $0.name.lowercased().contains(title.lowercased() )})
    }
    
    public func ordered() -> [SFDataSection<SFChat>] {
        
        var sections: [SFDataSection<SFChat>] = []
        
        for chat in self {
            if let index = sections.index(where: { $0.identifier == chat.modificationDate.string(with: "EEEE dd MMM yyyy") }) {
                sections[index].content.append(chat)
            } else {
                let section = SFDataSection<SFChat>(content: [chat], identifier: chat.modificationDate.string(with: "EEEE dd MMM yyyy"))
                sections.append(section)
            }
        }
        
        sections.sort(by: { (current, next) -> Bool in
            guard let currentDate = Date.date(from: current.identifier, with: "EEEE dd MMM yyyy") else { return false }
            guard let nextDate = Date.date(from: next.identifier, with: "EEEE dd MMM yyyy") else { return false }
            return currentDate < nextDate
        })
        
        for (index, var section) in sections.enumerated() {
            section.content.sort { (current, next) -> Bool in
                return current.modificationDate > next.modificationDate
            }
            sections[index] = section
        }
        
        return sections
    }
    
}
