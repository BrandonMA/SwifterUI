//
//  SFConversationView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/29/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFConversationView: SFView {
    
    // MARK: - Instance Properties
    
    open lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 28
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
        return indicator
    }()
    
    open lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = SFAssets.imageOfArrowRight.withRenderingMode(.alwaysTemplate)
        return imageView
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
        verticalStackView.spacing = 8
        return verticalStackView
    }()
    
    private lazy var stackView: SFStackView = {
        let stackView = SFStackView(arrangedSubviews: [profileImageView, verticalStackView, rightImageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        addSubview(stackView)
        nameLabel.setContentCompressionResistancePriority(.init(249), for: .horizontal)
        hourLabel.setContentCompressionResistancePriority(.init(251), for: .horizontal)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        stackView.clipSides(margin: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        profileImageView.setWidth(SFDimension(value: 56))
        notificationIndicator.setWidth(SFDimension(value: 24))
        notificationIndicator.setHeight(SFDimension(value: 24))
        rightImageView.setWidth(SFDimension(value: 8.80))
        rightImageView.setHeight(SFDimension(value: 16))
        super.setConstraints()
    }
    
    open override func updateColors() {
        super.updateColors()
        rightImageView.tintColor = colorStyle.placeholderColor
    }
    
}
