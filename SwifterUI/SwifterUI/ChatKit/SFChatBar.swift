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
    // if you don't height constraint is not going to work automatically
    open override var intrinsicContentSize: CGSize {
        guard let window = UIApplication.shared.keyWindow else { fatalError() }
        return CGSize(width: window.bounds.width, height: 0)
    }

    public final lazy var contentView: SFView = {
        let view = SFView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public final lazy var textView: SFTextView = {
        let textView = SFTextView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 15)
        textView.layer.cornerRadius = 10
        return textView
    }()

    public final lazy var sendButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.setTitle("Enviar", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.useClearColor = true
        button.addTouchAnimations = true
        return button
    }()

    public final lazy var fileButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.useClearColor = true
        button.setImage(SFAssets.imageOfPlus.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .center
        button.useAlternativeTextColor = true
        button.addTouchAnimations = true
        return button
    }()

    // MARK: - Initializers

    public override init(automaticallyAdjustsColorStyle: Bool, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(sendButton)
        contentView.addSubview(fileButton)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance Methods
    
    open override func updateConstraints() {
        contentView.clipEdges(exclude: [.top])
        contentView.height(SFDimension(value: 49))
        
        sendButton.clipEdges(margin: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8),
                             exclude: [.left],
                             useSafeArea: false)
        sendButton.width(SFDimension(value: 58))
        
        fileButton.clipEdges(margin: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                             exclude: [.right, .left],
                             useSafeArea: false)
        fileButton.clipRight(to: .left, of: sendButton, margin: 8, useSafeArea: false)
        fileButton.width(SFDimension(value: 28))
        
        textView.clipEdges(margin: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0),
                           exclude: [.right],
                           useSafeArea: false)
        textView.clipRight(to: .left, of: fileButton, margin: 8, useSafeArea: false)
        
        clipTop(to: .top, of: contentView)
        super.updateConstraints()
    }

}
