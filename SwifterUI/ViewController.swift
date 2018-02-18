//
//  ViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class Message: SFMessage {
    
    open var text: String?
    open var image: UIImage?
    open var videoURL: URL?
    open var fileURL: URL?
    public var isMine: Bool
    open var timestamp: Date
    
    public required init(text: String? = nil, image: UIImage? = nil, videoURL: URL? = nil, fileURL: URL? = nil, isMine: Bool = true, timestamp: Date) {
        self.text = text
        self.image = image
        self.videoURL = videoURL
        self.fileURL = fileURL
        self.isMine = isMine
        self.timestamp = timestamp
    }
    
}


























