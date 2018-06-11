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
        return label
    }()
    
    public final lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouchImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    public final lazy var messageVideoView: SFVideoView = {
        let videoView = SFVideoView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        return videoView
    }()
    
    private var initialFrame: CGRect = .zero
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        useAlternativeColors = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    @objc public final func didTouchImageView() {
        delegate?.didSelectImageView(cell: self)
    }
    
    //    public final func zoomIn() {
    //                guard let window = UIApplication.shared.keyWindow else { return }
    //                messageImageView.removeAllConstraints()
    //                messageImageView.frame = window.convert(messageImageView.bounds, from: messageImageView)
    //                initialFrame = messageImageView.frame
    //                window.addSubview(messageImageView)
    //                messageImageView.clipEdges()
    //                UIView.animate(withDuration: 0.4, animations: {
    //                    window.layoutIfNeeded()
    //                }, completion: { (_) in
    //                    self.delegate?.didZoomIn(cell: self)
    //                })
    //    }
    
    //        public final func zoomOut() {
    //            UIView.animate(withDuration: 0.4, animations: {
    //                self.messageImageView.frame = self.initialFrame
    //            }, completion: { (_) in
    //                self.delegate?.didZoomOut(cell: self)
    //                self.messageImageView.removeAllConstraints()
    //                self.layoutSubviews()
    //            })
    //        }
    
    public final override func prepareForReuse() {
        messageVideoView.removeFromSuperview()
        messageImageView.removeFromSuperview()
        super.prepareForReuse()
    }
    
    public final override func layoutSubviews() {
        super.layoutSubviews()
        bubbleView.remove(constraintType: .width)
        bubbleView.remove(constraintType: .left)
        bubbleView.remove(constraintType: .right)
        messageVideoView.removeAllConstraints()
        
        bubbleView.clipTop(to: .top, margin: 8)
        bubbleView.clipBottom(to: .bottom, margin: 8)
        bubbleView.width(SFDimension(value: width + 17))
        
        if isMine {
            bubbleView.clipRight(to: .right, margin: 8)
        } else {
            bubbleView.clipLeft(to: .left, margin: 8)
        }
        
        messageLabel.clipEdges(margin: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        if messageImageView.image != nil {
            bubbleView.addSubview(messageImageView)
            messageImageView.clipEdges(margin: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        } else if messageVideoView.url != nil {
            bubbleView.addSubview(messageVideoView)
            messageVideoView.prepareVideoView()
            messageVideoView.clipEdges(margin: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
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
    }
}
