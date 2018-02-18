//
//  SFTableViewChatCell.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFTableViewChatCellDelegate: class {
    func didZoomIn(cell: SFTableViewChatCell)
    func didZoomOut(cell: SFTableViewCell)
}

public extension SFTableViewChatCellDelegate {
    public func didZoomIn(cell: SFTableViewChatCell) {
    }
    
    public func didZoomOut(cell: SFTableViewCell) {
    }
}

open class SFTableViewChatCell: SFTableViewCell {
    
    // MARK: - Instance Properties
    
    open weak var delegate: SFTableViewChatCellDelegate? = nil
    
    open var isBlue: Bool = false
    open var width: CGFloat = 0
    
    open lazy var bubbleView: SFView = {
        let view = SFView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    open lazy var messageLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    open lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouchImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    open lazy var messageVideoView: SFVideoView = {
        let videoView = SFVideoView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        return videoView
    }()
    
    private var initialFrame: CGRect = .zero
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bubbleView)
        useAlternativeColors = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    @objc open func didTouchImageView() {
        
        if messageImageView.superview == window {
            zoomOut()
        } else {
            zoomIn()
        }
    }
    
    open func zoomIn() {
        guard let window = UIApplication.shared.keyWindow else { return }
        messageImageView.removeAllConstraints()
        messageImageView.frame = window.convert(messageImageView.bounds, from: messageImageView)
        initialFrame = messageImageView.frame
        window.addSubview(messageImageView)
        messageImageView.clipEdges()
        UIView.animate(withDuration: 0.4, animations: {
            window.layoutIfNeeded()
        }) { (finished) in
            self.delegate?.didZoomIn(cell: self)
        }
    }
    
    open func zoomOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.messageImageView.frame = self.initialFrame
        }) { (finished) in
            self.delegate?.didZoomOut(cell: self)
            self.messageImageView.removeAllConstraints()
            self.layoutSubviews()
        }
    }
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        
        bubbleView.removeAllConstraints()
        
        bubbleView.clipTop(to: .top, margin: 8)
        bubbleView.clipBottom(to: .bottom, margin: 8)
        bubbleView.width(SFDimension(value: width + 17))
        
        if isBlue {
            bubbleView.clipLeft(to: .left, margin: 8)
        } else {
            bubbleView.clipRight(to: .right, margin: 8)
        }
        
        if messageImageView.image != nil {
            bubbleView.addSubview(messageImageView)
            messageImageView.clipEdges(margin: ConstraintMargin(top: 8, right: 8, bottom: 8, left: 8))
        } else if messageVideoView.url != nil {
            bubbleView.addSubview(messageVideoView)
            messageVideoView.prepareVideoView()
            messageVideoView.clipEdges(margin: ConstraintMargin(top: 8, right: 8, bottom: 8, left: 8))
        } else {
            bubbleView.addSubview(messageLabel)
            messageLabel.clipEdges(margin: ConstraintMargin(top: 8, right: 8, bottom: 8, left: 8))
        }
        
        
    }
    
}
