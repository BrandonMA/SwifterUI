//
//  SFTableViewChatCell.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFCollectionViewConversationCell: SFCollectionViewCell {
    
    // MARK: - Class Properties
    
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
        layer.cornerRadius = 8
        clipsToBounds = true
        addShadow(color: .black, offSet: CGSize(width: 0, height: 6), radius: 10, opacity: 0.05)
        contentView.addSubview(conversationView)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        conversationView.clipSides()
        super.setConstraints()
    }
}
