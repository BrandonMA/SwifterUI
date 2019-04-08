//
//  SFModalView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 16/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFBulletinView: SFPopView {
    
    // MARK: - Instance Properties
    
    public final lazy var closeButton: SFFluidButton = {
        let button = SFFluidButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.imageView.image = SFAssets.imageOfClose.withRenderingMode(.alwaysTemplate)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    
    public final lazy var doneButton: SFFluidButton = {
        let button = SFFluidButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.title = "Listo"
        return button
    }()
    
    public final lazy var titleLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = .boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    public final lazy var messageLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.useAlternativeColors = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var buttons: [SFFluidButton] = []
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true,
                useAlternativeColors: Bool = false,
                frame: CGRect = .zero,
                middleView: UIView? = nil,
                buttons: [SFFluidButton] = []) {
        
        self.buttons = buttons
        
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle,
                   useAlternativeColors: useAlternativeColors,
                   frame: frame,
                   middleView: middleView ?? SFView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        
        contentView.addSubview(closeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(middleView)
        
        if buttons.count > 0 {
            middleView.translatesAutoresizingMaskIntoConstraints = false
            buttons.forEach({ (button) in
                button.translatesAutoresizingMaskIntoConstraints = false
                button.layer.cornerRadius = 16
                button.useHighlightTextColor = true
                middleView.addSubview(button)
            })
        } else {
            contentView.addSubview(doneButton)
        }
        
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        
        super.setConstraints()
        
        closeButton.setWidth(SFDimension(value: 32))
        closeButton.setHeight(SFDimension(value: 32))
        closeButton.clipBottom(to: .top, of: messageLabel, margin: 12)
        closeButton.clipRight(to: .right, margin: 12)
        
        titleLabel.clipRight(to: .right, margin: 24)
        titleLabel.clipLeft(to: .left, margin: 24)
        titleLabel.clipCenterY(to: .centerY, of: closeButton)
        
        messageLabel.clipRight(to: .right, margin: 12)
        messageLabel.clipLeft(to: .left, margin: 12)
        messageLabel.clipBottom(to: .top, of: middleView, margin: 12)
        
        contentView.removeConstraint(type: .bottom)
        contentView.removeConstraint(type: .top)
        contentView.removeConstraint(type: .centerY)
        contentView.clipBottom(to: .bottom, margin: 12)
        contentView.clipTop(to: .top, of: closeButton, margin: -12)
        
        if buttons.count > 0 {
            middleView.clipBottom(to: .bottom, margin: 12)
            for (index, button) in buttons.enumerated() {
                button.clipRight(to: .right)
                button.clipLeft(to: .left)
                button.setHeight(SFDimension(value: 48))
                if index == 0 {
                    button.clipBottom(to: .bottom)
                } else {
                    button.clipBottom(to: .top, of: buttons[index - 1], margin: 12)
                }
                if index == buttons.count - 1 {
                    middleView.clipTop(to: .top, of: button)
                }
            }
        } else {
            doneButton.clipSides(exclude: [.top], margin: UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12))
            doneButton.setHeight(SFDimension(value: 48))
            middleView.clipBottom(to: .top, of: doneButton)
            middleView.setHeight(SFDimension(value: 200))
        }
        
    }
}
