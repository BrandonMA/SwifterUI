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
    
    open lazy var textView: SFTextView = {
        let textView = SFTextView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 13)
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    open lazy var sendButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.setTitle("Enviar", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.useClearColor = true
        return button
    }()
    
    open lazy var fileButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.useClearColor = true
        button.setImage(SFAssets.imageOfPlus.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .center
        button.useAlternativeTextColor = true
        return button
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        addSubview(textView)
        addSubview(sendButton)
        addSubview(fileButton)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        sendButton.clipEdges(margin: ConstraintMargin(top: 0, right: 8, bottom: 0, left: 0), exclude: [.left])
        sendButton.width(SFDimension(value: 58))
        
        fileButton.clipEdges(margin: ConstraintMargin(top: 0, right: 0, bottom: 0, left: 0), exclude: [.right, .left])
        fileButton.clipRight(to: .left, of: sendButton, margin: 8)
        fileButton.width(SFDimension(value: 28))
        
        textView.clipEdges(margin: ConstraintMargin(top: 8, right: 0, bottom: 8, left: 8), exclude: [.right])
        textView.clipRight(to: .left, of: fileButton, margin: 8)
    }
    
}
