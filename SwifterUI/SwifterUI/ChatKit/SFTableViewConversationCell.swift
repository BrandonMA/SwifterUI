//
//  SFTableViewChatCell.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTableViewConversationCell: SFTableViewCell {    
    
    // MARK: - Instance Properties
    
    open lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    open lazy var nameLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
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
        label.textAlignment = .right
        return label
    }()
    
    open lazy var notificationIndicator: SFNotificationIndicator = {
        let indicator = SFNotificationIndicator(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.alpha = 0
        return indicator
    }()
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(hourLabel)
        contentView.addSubview(notificationIndicator)
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
        nameLabel.clipRight(to: .left, of: hourLabel, margin: 12)
        
        notificationIndicator.width(SFDimension(value: 12))
        notificationIndicator.height(SFDimension(value: 12))
        notificationIndicator.clipRight(to: .right, margin: 12)
        notificationIndicator.clipCenterY(to: .centerY, of: messageLabel)
        
        messageLabel.clipBottom(to: .bottom, of: profileImageView)
        messageLabel.clipLeft(to: .right, of: profileImageView, margin: 12)
        messageLabel.clipRight(to: .left, of: notificationIndicator, margin: 12)
        
        hourLabel.clipTop(to: .top, of: profileImageView)
        hourLabel.clipRight(to: .right, margin: 12)
        
    }
}

public extension SFTableViewConversationCell {
    
    // MARK: - Static Methods
    
    public func height() -> CGFloat {
        return 64
    }
    
    public func identifier() -> String {
        return "SFTableViewConversationCell"
    }
    
}























