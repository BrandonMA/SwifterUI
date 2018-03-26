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
        case identifier
        case senderidentifier
        case text
        case imageURL
        case videoURL
        case fileURL
        case timestamp
    }

    // MARK: - Instance Properties

    open var identifier: String
    open var senderidentifier: String
    open var text: String?
    open var imageURL: String?
    open var image: UIImage?
    open var videoURL: URL?
    open var fileURL: URL?
    open var timestamp: Date
    open var isMine: Bool = true

    // MARK: - Initializers

    public required init(senderidentifier: String,
                         text: String? = nil,
                         image: UIImage? = nil,
                         videoURL: URL? = nil,
                         fileURL: URL? = nil,
                         timestamp: Date,
                         isMine: Bool) {
        self.identifier = ""
        self.senderidentifier = senderidentifier
        self.text = text
        self.image = image
        self.imageURL = nil
        self.videoURL = videoURL
        self.fileURL = fileURL
        self.timestamp = timestamp
        self.isMine = isMine
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try values.decode(String.self, forKey: .identifier)
        senderidentifier = try values.decode(String.self, forKey: .senderidentifier)
        text = try values.decode(String?.self, forKey: .text)
        image = nil
        imageURL = try values.decode(String?.self, forKey: .imageURL)
        videoURL = try values.decode(URL?.self, forKey: .videoURL)
        fileURL = try values.decode(URL?.self, forKey: .fileURL)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
    }

    // MARK: - Instance Methods

    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(senderidentifier, forKey: .senderidentifier)
        try container.encode(text, forKey: .text)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(videoURL, forKey: .videoURL)
        try container.encode(fileURL, forKey: .fileURL)
        try container.encode(timestamp, forKey: .timestamp)
    }

}

extension SFMessage: Hashable {

    public var hashValue: Int {
        return identifier.hashValue
    }

    public static func == (lhs: SFMessage, rhs: SFMessage) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}
