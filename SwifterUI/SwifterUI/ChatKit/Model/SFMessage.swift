//
//  SFMessage.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit

open class SFMessage: Hashable {
    
    // MARK: - Static Methods
    
    public static func == (lhs: SFMessage, rhs: SFMessage) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.chatIdentifier == rhs.chatIdentifier && lhs.creationDate == rhs.creationDate
    }
    
    // MARK: - Instance Properties
    
    open var identifier: String
    open var senderIdentifier: String
    open var text: String?
    open var imageURL: String?
    open var videoURL: String?
    open var fileURL: String?
    open var creationDate: Date = Date()
    open var read: Bool = false
    open var chatIdentifier: String
    
    open var hashValue: Int { return identifier.hashValue }
    open var image: UIImage?
    
    // MARK: - Initializers
    
    public init(senderIdentifier: String, text: String? = nil, imageURL: String? = nil, image: UIImage? = nil, videoURL: String? = nil, fileURL: String? = nil, creationDate: Date = Date(), read: Bool = false, chatIdentifier: String) {
        self.identifier = UUID().uuidString
        self.senderIdentifier = senderIdentifier
        self.text = text
        self.image = image
        self.imageURL = imageURL
        self.videoURL = videoURL
        self.fileURL = fileURL
        self.creationDate = creationDate
        self.read = read
        self.chatIdentifier = chatIdentifier
    }
    
}

public extension Array where Element: SFMessage {
    
    public func ordered() -> [SFDataSection<SFMessage>] {
        
        var sections: [SFDataSection<SFMessage>] = []
        
        for message in self {
            
            if let index = sections.index(where: { $0.identifier == message.creationDate.string(with: "EEEE dd MMM yyyy") }) {
                sections[index].content.append(message)
            } else {
                let section = SFDataSection<SFMessage>(content: [message], identifier: message.creationDate.string(with: "EEEE dd MMM yyyy"))
                sections.append(section)
            }
        }
        
        sections.sort(by: { (current, next) -> Bool in
            guard let currentDate = Date.date(from: current.identifier, with: "EEEE dd MMM yyyy") else { return false }
            guard let nextDate = Date.date(from: next.identifier, with: "EEEE dd MMM yyyy") else { return false }
            return currentDate < nextDate
        })
        
        return sections
    }
    
}












