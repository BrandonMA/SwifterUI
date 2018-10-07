//
//  SFSingleChat.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 09/09/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSingleChat: SFChat {
    
    // MARK: - Instance Properties
    
    open override var imageURL: String? {
        get {
            return contact?.profilePictureURL
        } set {
            contact?.profilePictureURL = newValue
        }
    }
    
    open weak var contact: SFUser?
    
}








