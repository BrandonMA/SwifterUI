//
//  SFMessage.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFMessage {
    var text: String? { get set }
    var image: UIImage? { get set }
    var videoURL: URL? { get set }
    var fileURL: URL? { get set }
    var timestamp: Date { get set }
    var isMine: Bool { get set }
    
    init(text: String?, image: UIImage?, videoURL: URL?, fileURL: URL?, isMine: Bool, timestamp: Date)
}
