//
//  SFTableViewChatCell.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTableViewConversationCell: SFTableViewCell {
    
    // MARK: - Static Properties
    
    open static let height: CGFloat = 64
    
    // MARK: - Instance Properties
    
    open lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    open lazy var nameLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    open lazy var messageLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.useAlternativeColors = true
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    open lazy var hourLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.useAlternativeColors = true
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(messageLabel)
        addSubview(hourLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        
        profileImageView.height(SFDimension(value: 40))
        profileImageView.width(SFDimension(value: 40))
        profileImageView.clipLeft(to: .left, margin: 12)
        profileImageView.center(axis: [.y])
        
        nameLabel.clipTop(to: .top, of: profileImageView)
        nameLabel.clipLeft(to: .right, of: profileImageView, margin: 12)
        nameLabel.clipRight(to: .left, of: hourLabel)
        
        messageLabel.clipBottom(to: .bottom, of: profileImageView)
        messageLabel.clipLeft(to: .right, of: profileImageView, margin: 12)
        messageLabel.clipRight(to: .right)
        
        hourLabel.clipTop(to: .top, of: profileImageView)
        hourLabel.clipRight(to: .right, margin: 12)
        
    }
}
























