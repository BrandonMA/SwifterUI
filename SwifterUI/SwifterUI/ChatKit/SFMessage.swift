//
//  SFMessage.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFMessage {
    
    // MARK: - Initializers
    
    init(senderId: String, text: String?, image: UIImage?, videoURL: URL?, fileURL: URL?, timestamp: Date)
    
    // MARK: - Instance Properties
    
    var id: String { get set }
    var senderId: String { get set }
    var text: String? { get set }
    var image: UIImage? { get set }
    var imageURL: String? { get set }
    var videoURL: URL? { get set }
    var fileURL: URL? { get set }
    var timestamp: Date { get set }
    var isMine: Bool { get set }
    
}

