//
//  SFChatBar.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFChatBar: SFView {
    
    // MARK: - Instance Properties
    
    // You must override intrinsicContentSize for auto layout to work properly,
    // if you don't, the height constraint is not going to work automatically
    open override var intrinsicContentSize: CGSize {
        guard let window = UIApplication.shared.keyWindow else { fatalError() }
        return CGSize(width: window.bounds.width, height: 0)
    }
    
    public final lazy var contentView: SFView = {
        let view = SFView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.addShadow(color: .black, offSet: CGSize(width: 0, height: 8), radius: 4, opacity: 0.03)
        return view
    }()
    
    public final lazy var textView: SFTextView = {
        let textView = SFTextView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 15)
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    public final lazy var sendButton: SFChatBarButton = {
        let button = SFChatBarButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView.image = SFAssets.imageOfSendIcon.withRenderingMode(.alwaysTemplate)
        button.layer.cornerRadius = 14
        button.alpha = 0.0
        return button
    }()
    
    public final lazy var fileButton: SFChatBarButton = {
        let button = SFChatBarButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView.image = SFAssets.imageOfExtraIcon.withRenderingMode(.alwaysTemplate)
        button.layer.cornerRadius = 14
        return button
    }()
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        useAlternativeColors = true
        addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(sendButton)
        contentView.addSubview(fileButton)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        
        contentView.clipSides(exclude: [.top], margin: UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12))
        contentView.set(height: SFDimension(value: 49))
        
        sendButton.set(width: SFDimension(value: 28))
        sendButton.set(height: SFDimension(value: 28))
        sendButton.clipCenterY(to: .centerY)
        sendButton.clipRight(to: .right, margin: -28, useSafeArea: false)
        
        fileButton.clipCenterY(to: .centerY)
        fileButton.clipLeft(to: .left, margin: 8, useSafeArea: false)
        fileButton.set(width: SFDimension(value: 28))
        fileButton.set(height: SFDimension(value: 28))
        
        textView.clipSides(exclude: [.right, .left],
                           margin: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0),
                           useSafeArea: false)
        textView.clipRight(to: .left, of: sendButton, margin: 8, useSafeArea: false)
        textView.clipLeft(to: .right, of: fileButton, margin: 8, useSafeArea: false)
        
        clipTop(to: .top, of: contentView)
        super.setConstraints()
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        updateSubviewsColors()
    }
    
}
