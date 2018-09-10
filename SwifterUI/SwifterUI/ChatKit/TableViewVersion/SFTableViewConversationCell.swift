//
//  SFTableViewConversationCell.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/30/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTableViewConversationCell: SFTableViewCell {
    
    // MARK: - Class Properties
    
    open override class var height: CGFloat {
        return 72
    }
    
    open override class var identifier: String {
        return "SFTableViewConversationCell"
    }
    
    // MARK: - Instance Properties
    
    open lazy var conversationView: SFConversationView = {
        let conversationView = SFConversationView()
        conversationView.clipsToBounds = true
        conversationView.translatesAutoresizingMaskIntoConstraints = false
        return conversationView
    }()
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        contentView.addSubview(conversationView)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        conversationView.clipSides()
        super.setConstraints()
    }
}

