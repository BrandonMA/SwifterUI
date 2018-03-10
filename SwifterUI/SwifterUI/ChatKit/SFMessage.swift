//
//  SFMessage.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFMessage: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case senderId
        case text
        case imageURL
        case videoURL
        case fileURL
        case timestamp
        case isMine
    }
    
    // MARK: - Instance Properties
    
    open var id: String
    open var senderId: String
    open var text: String? = nil
    open var image: UIImage? = nil
    open var imageURL: String? = nil
    open var videoURL: URL? = nil
    open var fileURL: URL? = nil
    open var timestamp: Date
    open var isMine: Bool
    
    // MARK: - Initializers
    
    public required init(senderId: String, text: String? = nil, image: UIImage? = nil, videoURL: URL? = nil, fileURL: URL? = nil, timestamp: Date) {
        self.id = ""
        self.senderId = senderId
        self.text = text
        self.image = image
        self.imageURL = nil
        self.videoURL = videoURL
        self.fileURL = fileURL
        self.timestamp = timestamp
        self.isMine = id == senderId
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.senderId = try values.decode(String.self, forKey: .senderId)
        self.text = try values.decode(String.self, forKey: .text)
        self.image = nil
        self.imageURL = try values.decode(String.self, forKey: .imageURL)
        self.videoURL = try values.decode(URL.self, forKey: .videoURL)
        self.fileURL = try values.decode(URL.self, forKey: .fileURL)
        self.timestamp = try values.decode(Date.self, forKey: .timestamp)
        self.isMine = id == senderId
    }
    
}

extension SFMessage: Hashable {
    
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func ==(lhs: SFMessage, rhs: SFMessage) -> Bool {
        return lhs.id == rhs.id
    }
    
}





















