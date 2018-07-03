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
