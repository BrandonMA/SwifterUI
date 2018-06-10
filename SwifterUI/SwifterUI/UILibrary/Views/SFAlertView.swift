//
//  SFAlertView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 08/04/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFAlertView: SFView {
    
    // MARK: - Instance Properties
    
    private final lazy var shadowView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.5
        view.backgroundColor = .black
        return view
    }()
    
    public final lazy var backgroundView: SFView = {
        let view = SFView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.addShadow(color: .black, offSet: CGSize(width: 0, height: 12), radius: 16, opacity: 0.15)
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    public final lazy var contentView: SFView = {
        let view = SFView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    public final lazy var titleLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = .boldSystemFont(ofSize: 19)
        label.text = "Titulo"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    public final lazy var messageLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.useAlternativeColors = true
        label.numberOfLines = 0
        return label
    }()
    
    private var buttons: [SFButton] = []
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero, title: String, message: String, buttons: [SFButton]) {
        self.buttons = buttons
        
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        
        titleLabel.text = title
        messageLabel.text = message
        
        addSubview(shadowView)
        addSubview(backgroundView)
        
        backgroundView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        
        if buttons.count > 0 {
            buttons.forEach({ (button) in
                button.translatesAutoresizingMaskIntoConstraints = false
                button.useAlternativeColors = true
                button.addTouchAnimations = true
                contentView.addSubview(button)
            })
        }
        
        updateColors()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func updateConstraints() {
        
        shadowView.clipEdges(useSafeArea: false)
        
        if useCompactInterface {
            backgroundView.width(SFDimension(type: .fraction, value: 11/12))
        } else {
            backgroundView.width(SFDimension(type: .fraction, value: 1/2))
        }
        
        backgroundView.height(SFDimension(value: 100), relation: .greater)
        backgroundView.center()
        
        contentView.clipEdges()
        
        titleLabel.clipTop(to: .top, margin: 12)
        titleLabel.clipRight(to: .right, margin: 12)
        titleLabel.clipLeft(to: .left, margin: 12)
        
        messageLabel.clipTop(to: .bottom, of: titleLabel, margin: 12)
        messageLabel.clipRight(to: .right, margin: 12)
        messageLabel.clipLeft(to: .left, margin: 12)
        
        for (index, button) in buttons.enumerated() {
            button.clipRight(to: .right)
            button.clipLeft(to: .left)
            button.height(SFDimension(value: 48))
            
            if index == 0 {
                button.clipTop(to: .bottom, of: messageLabel, margin: 12)
            } else {
                button.clipTop(to: .bottom, of: buttons[index - 1])
            }
            
            if index == buttons.count - 1 {
                backgroundView.clipBottom(to: .bottom, of: button)
            }
        }
        
        super.updateConstraints()
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        buttons.forEach { (button) in
            button.addShadow(color: colorStyle.getSeparatorColor(), offSet: CGSize(width: 0, height: -1), radius: 0, opacity: 1)
        }
        updateSubviewsColors()
    }
}
