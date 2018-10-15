//
//  SFMessage.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import Kingfisher

open class SFMessage: Hashable, Codable {
    
    public enum CodingKeys: String, CodingKey {
        case identifier
        case senderIdentifier
        case text
        case imageURL
        case videoURL
        case creationDate
        case read
        case chatIdentifier
    }
    
    // MARK: - Static Methods
    
    public static func == (lhs: SFMessage, rhs: SFMessage) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.chatIdentifier == rhs.chatIdentifier
    }
    
    // MARK: - Instance Properties
    
    open var identifier: String
    open var senderIdentifier: String
    open var chatIdentifier: String
    open var creationDate: Date
    open var read: Bool
    open var text: String?
    open var imageURL: String?
    open var videoURL: String?
    
    open var hashValue: Int {
        return identifier.hashValue ^ chatIdentifier.hashValue
    }
    open var image: UIImage? = nil
    open weak var sender: SFUser?
    
    // MARK: - Initializers
    
    public init(identifier: String = UUID().uuidString, senderIdentifier: String, chatIdentifier: String, creationDate: Date = Date(), read: Bool = false) {
        self.identifier = identifier
        self.senderIdentifier = senderIdentifier
        self.chatIdentifier = chatIdentifier
        self.creationDate = creationDate
        self.read = read
    }
    
    public convenience init(identifier: String = UUID().uuidString,
                            senderIdentifier: String,
                            chatIdentifier: String,
                            creationDate: Date = Date(),
                            read: Bool = false,
                            text: String) {
        
        self.init(identifier: identifier,
                  senderIdentifier: senderIdentifier,
                  chatIdentifier: chatIdentifier,
                  creationDate: creationDate,
                  read: read)
        self.text = text
    }
    
    public convenience init(identifier: String = UUID().uuidString,
                            senderIdentifier: String,
                            chatIdentifier: String,
                            creationDate: Date = Date(),
                            read: Bool = false,
                            image: UIImage,
                            imageURL: String) {
        
        self.init(identifier: identifier,
                  senderIdentifier: senderIdentifier,
                  chatIdentifier: chatIdentifier,
                  creationDate: creationDate,
                  read: read)
        self.image = image
        self.imageURL = imageURL
    }
    
    public convenience init(identifier: String = UUID().uuidString,
                            senderIdentifier: String,
                            chatIdentifier: String,
                            creationDate: Date = Date(),
                            read: Bool = false,
                            videoURL: String) {
        
        self.init(identifier: identifier,
                  senderIdentifier: senderIdentifier,
                  chatIdentifier: chatIdentifier,
                  creationDate: creationDate,
                  read: read)
        self.videoURL = videoURL
    }
    
    public required init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try data.decode(String.self, forKey: CodingKeys.identifier)
        senderIdentifier = try data.decode(String.self, forKey: CodingKeys.senderIdentifier)
        chatIdentifier = try data.decode(String.self, forKey: CodingKeys.chatIdentifier)
        text = try data.decode(String.self, forKey: CodingKeys.text)
        imageURL = try data.decode(String?.self, forKey: CodingKeys.imageURL)
        videoURL = try data.decode(String?.self, forKey: CodingKeys.videoURL)
        creationDate = try data.decode(Date.self, forKey: CodingKeys.creationDate)
        read = try data.decode(Bool.self, forKey: CodingKeys.read)
    }
    
    // MARK: - Instance Methods
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: CodingKeys.identifier)
        try container.encode(senderIdentifier, forKey: CodingKeys.senderIdentifier)
        try container.encode(chatIdentifier, forKey: CodingKeys.chatIdentifier)
        try container.encode(text, forKey: CodingKeys.text)
        try container.encode(imageURL, forKey: CodingKeys.imageURL)
        try container.encode(videoURL, forKey: CodingKeys.videoURL)
        try container.encode(creationDate, forKey: CodingKeys.creationDate)
        try container.encode(read, forKey: CodingKeys.read)
    }
}

public extension Array where Element: SFDataSection<SFMessage> {
    public mutating func sortByDate() {
        sort(by: { (current, next) -> Bool in
            guard let currentDate = Date.date(from: current.identifier, with: "EEEE dd MMM yyyy") else { return false }
            guard let nextDate = Date.date(from: next.identifier, with: "EEEE dd MMM yyyy") else { return false }
            return currentDate < nextDate
        })
    }
}

public extension Array where Element: SFMessage {
    
    public func createDataSections() -> [SFDataSection<SFMessage>] {
        
        var sections: [SFDataSection<SFMessage>] = []
        
        for message in self {
            
            if let index = sections.index(where: {
                $0.identifier == message.creationDate.string(with: "EEEE dd MMM yyyy")
            }) {
                sections[index].content.append(message)
            } else {
                let section = SFDataSection<SFMessage>(content: [message], identifier: message.creationDate.string(with: "EEEE dd MMM yyyy"))
                sections.append(section)
            }
        }
        
        return sections
        
    }
    
    public func ordered() -> [SFDataSection<SFMessage>] {
        var sections: [SFDataSection<SFMessage>] = createDataSections()
        sections.sortByDate()
        return sections
    }
    
}












