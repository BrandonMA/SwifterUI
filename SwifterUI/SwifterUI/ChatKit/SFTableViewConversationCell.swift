//
//  SFTableViewChatCell.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
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
    
    open lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    open lazy var nameLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    open lazy var messageLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.useAlternativeColors = true
        label.font = UIFont.systemFont(ofSize: 15)
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
    
    private lazy var topStackView: SFStackView = {
        let topStackView = SFStackView(arrangedSubviews: [nameLabel, hourLabel])
        topStackView.axis = .horizontal
        topStackView.alignment = .fill
        topStackView.distribution = .fill
        topStackView.spacing = 8
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        return topStackView
    }()
    
    private lazy var bottomStackView: SFStackView = {
        let bottomStackView = SFStackView(arrangedSubviews: [messageLabel, notificationIndicator])
        bottomStackView.axis = .horizontal
        bottomStackView.alignment = .center
        bottomStackView.distribution = .fill
        bottomStackView.spacing = 8
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        return bottomStackView
    }()
    
    private lazy var verticalStackView: SFStackView = {
        let verticalStackView = SFStackView(arrangedSubviews: [topStackView, bottomStackView])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    private lazy var stackView: SFStackView = {
        let stackView = SFStackView(arrangedSubviews: [profileImageView, verticalStackView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        nameLabel.setContentCompressionResistancePriority(.init(249), for: .horizontal)
        hourLabel.setContentCompressionResistancePriority(.init(251), for: .horizontal)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if mainContraints.isEmpty {
            mainContraints.append(contentsOf: stackView.clipEdges(margin: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)))
            mainContraints.append(profileImageView.width(SFDimension(value: 48)))
            mainContraints.append(notificationIndicator.width(SFDimension(value: 20)))
            mainContraints.append(notificationIndicator.height(SFDimension(value: 20)))
        }
    }
}
