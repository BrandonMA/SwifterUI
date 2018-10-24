//
//  SFTableViewChatCell.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFTableViewChatCellDelegate: class {
    
    // MARK: - Instance Methods
    
    func didSelectImageView(cell: SFTableViewChatCell)
    
}

public final class SFTableViewChatCell: SFTableViewCell {
    
    // MARK: - Class Properties
    
    public final override class var height: CGFloat {
        return 0
    }
    
    public final override class var identifier: String {
        return "SFTableViewChatCell"
    }
    
    // MARK: - Instance Properties
    
    public final weak var delegate: SFTableViewChatCellDelegate?
    
    public final var isMine: Bool = false
    public final var width: CGFloat = 0
    
    public final lazy var bubbleView: SFBubbleView = {
        let view = SFBubbleView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    public final lazy var messageLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    
    public final lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouchImageView)))
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public final lazy var messageVideoView: SFVideoView = {
        let videoView = SFVideoView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.isUserInteractionEnabled = true
        return videoView
    }()
    
    public final lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public final lazy var timeLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, useAlternativeColors: true)
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
        
    // MARK: - Instance Methods
    
    public override func prepareSubviews() {
        
        contentView.addSubview(bubbleView)
        contentView.addSubview(userImageView)
        contentView.addSubview(timeLabel)
        
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(messageImageView)
        bubbleView.addSubview(messageVideoView)
        
        useAlternativeColors = true
        
        super.prepareSubviews()
    }
    
    @objc public final func didTouchImageView() {
        delegate?.didSelectImageView(cell: self)
    }
    
    public override func setConstraints() {
        
        userImageView.height(SFDimension(value: 32))
        userImageView.width(SFDimension(value: 32))
        userImageView.clipTop(to: .top, margin: 8)
        
        timeLabel.clipCenterY(to: .centerY, of: userImageView)
        
        bubbleView.clipTop(to: .bottom, of: userImageView, margin: 8)
        bubbleView.clipBottom(to: .bottom, margin: 8)
        
        messageLabel.clipSides(margin: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        messageImageView.clipSides()
        messageVideoView.clipSides()
        super.setConstraints()
    }
    
    public final override func layoutSubviews() {
        
        super.layoutSubviews()
        
        bubbleView.removeConstraint(type: .width)
        bubbleView.removeConstraint(type: .left)
        bubbleView.removeConstraint(type: .right)
        
        userImageView.removeConstraint(type: .left)
        userImageView.removeConstraint(type: .right)
        
        timeLabel.removeConstraint(type: .left)
        timeLabel.removeConstraint(type: .right)
        
        if messageImageView.image != nil {
            bubbleView.width(SFDimension(value: width))
        } else {
            bubbleView.width(SFDimension(value: width + 17))
        }
        
        if isMine {
            userImageView.clipRight(to: .right, margin: 12)
            timeLabel.clipRight(to: .left, of: userImageView, margin: 8)
            bubbleView.clipRight(to: .right, margin: 12)
        } else {
            userImageView.clipLeft(to: .left, margin: 12)
            timeLabel.clipLeft(to: .right, of: userImageView, margin: 8)
            bubbleView.clipLeft(to: .left, margin: 12)
        }
    }
    
    public final override func updateColors() {
        if self.bubbleView.useAlternativeColors {
            messageLabel.automaticallyAdjustsColorStyle = false
            messageLabel.textColor = .white
        } else {
            messageLabel.automaticallyAdjustsColorStyle = true
        }
        
        super.updateColors()
        
        if messageImageView.image != nil {
            bubbleView.backgroundColor = .clear
        }
    }
}
