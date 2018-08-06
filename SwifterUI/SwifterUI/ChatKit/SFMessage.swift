//
//  SFMessage.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFMessage: Hashable {
    
    // MARK: - Instance Properties
    
    var identifier: String { get set }
    var senderIdentifier: String { get set }
    var text: String? { get set }
    var imageURL: URL? { get set }
    var image: UIImage? { get set }
    var videoURL: URL? { get set }
    var fileURL: URL? { get set }
    var timestamp: Date { get set }
    var isMine: Bool { get set }
    
    init(senderIdentifier: String, text: String?, image: UIImage?, videoURL: URL?, fileURL: URL?, timestamp: Date, isMine: Bool)
    
}

public extension SFMessage {
    
    public var hashValue: Int {
        return identifier.hashValue
    }
}

public extension Array where Element: SFMessage {
    public func orderMessages() -> [SFDataSection<Element>] {
        var sections: [SFDataSection<Element>] = []
         
        for message in self {
            if let index = sections.index(where: { $0.identifier == message.timestamp.string(with: "EEEE dd MMM yyyy") }) {
                sections[index].content.append(message)
            } else {
                let section = SFDataSection<Element>(content: [message], identifier: message.timestamp.string(with: "EEEE dd MMM yyyy"))
                sections.append(section)
            }
        }
        
        sections = sections.sorted(by: { (current, next) -> Bool in
            guard let currentDate = Date.date(from: current.identifier, with: "EEEE dd MMM yyyy") else { return false }
            guard let nextDate = Date.date(from: next.identifier, with: "EEEE dd MMM yyyy") else { return false }
            return currentDate < nextDate
        })
        
        return sections
    }
}
