//
//  SFModalView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 16/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFBulletinView: SFView {
    
    // MARK: - Instance Properties
    
    public final lazy var shadowView: UIView = {
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
        view.layer.cornerRadius = 16
        view.addShadow(color: .black, offSet: CGSize(width: 0, height: 12), radius: 16, opacity: 0.15)
        return view
    }()
    
    public final lazy var closeButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.setImage(SFAssets.imageOfClose.withRenderingMode(.alwaysTemplate), for: .normal)
        button.useAlternativeTextColor = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        return button
    }()
    
    public final lazy var doneButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.useAlternativeTextColor = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setTitle("Listo", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTouchAnimations = true
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
    
    open var middleView: UIView
    
    private var buttons: [SFFluidButton] = []
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero, middleView: UIView? = nil, buttons: [SFFluidButton] = []) {
        
        self.middleView = middleView ?? SFView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        self.buttons = buttons
        
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        
        addSubview(shadowView)
        addSubview(backgroundView)
        
        backgroundView.addSubview(closeButton)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(messageLabel)
        backgroundView.addSubview(middleView)
        
        if buttons.count > 0 {
            middleView.translatesAutoresizingMaskIntoConstraints = false
            buttons.forEach({ (button) in
                button.translatesAutoresizingMaskIntoConstraints = false
                button.layer.cornerRadius = 16
                button.useHighlightTextColor = true
                middleView.addSubview(button)
            })
        } else {
            backgroundView.addSubview(doneButton)
        }
        
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        
        shadowView.clipEdges(useSafeArea: false)
        middleView.clipRight(to: .right, margin: 12)
        middleView.clipLeft(to: .left, margin: 12)
        closeButton.width(SFDimension(value: 32))
        closeButton.height(SFDimension(value: 32))
        closeButton.clipBottom(to: .top, of: messageLabel, margin: 12)
        closeButton.clipRight(to: .right, margin: 12)
        
        titleLabel.clipRight(to: .right, margin: 24)
        titleLabel.clipLeft(to: .left, margin: 24)
        titleLabel.center(axis: [.vertical], in: closeButton)
        
        messageLabel.clipRight(to: .right, margin: 12)
        messageLabel.clipLeft(to: .left, margin: 12)
        messageLabel.clipBottom(to: .top, of: middleView, margin: 12)
        
        backgroundView.clipBottom(to: .bottom, margin: 12)
        backgroundView.clipTop(to: .top, of: closeButton, margin: -12)
        backgroundView.clipCenterX(to: .centerX)
        
        if buttons.count > 0 {
            middleView.clipBottom(to: .bottom, margin: 12)
            for (index, button) in buttons.enumerated() {
                button.clipRight(to: .right)
                button.clipLeft(to: .left)
                button.height(SFDimension(value: 48))
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
            doneButton.clipEdges(exclude: [.top], margin: UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12))
            doneButton.height(SFDimension(value: 48))
            middleView.clipBottom(to: .top, of: doneButton)
            middleView.height(SFDimension(value: 200))
        }
        
        super.setConstraints()
    }
    
    open override func updateConstraints() {
        
        backgroundView.remove(constraintType: .width)
        
        if useCompactInterface {
            backgroundView.width(SFDimension(type: .fraction, value: 11/12))
        } else {
            backgroundView.width(SFDimension(type: .fraction, value: 1/2))
        }
        
        super.updateConstraints()
        
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        updateSubviewsColors()
    }
}





















