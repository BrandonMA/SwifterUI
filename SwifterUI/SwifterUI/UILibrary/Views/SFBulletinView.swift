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
    
    private final lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.text = "Titulo"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    open var middleView: UIView
    
    private var buttons: [SFButton] = []
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero, middleView: UIView? = nil, buttons: [SFButton] = []) {
        
        self.middleView = middleView ?? SFView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        self.buttons = buttons
        
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        
        isOpaque = false
        
        addSubview(blurView)
        addSubview(backgroundView)
        
        backgroundView.addSubview(closeButton)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(self.middleView)
        
        if buttons.count > 0 {
            self.middleView.translatesAutoresizingMaskIntoConstraints = false
            buttons.forEach({ (button) in
                button.translatesAutoresizingMaskIntoConstraints = false
                button.layer.cornerRadius = 16
                
                button.addTouchAnimations = true
                
                self.middleView.addSubview(button)
            })
        } else {
            backgroundView.addSubview(doneButton)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func updateConstraints() {
        
        blurView.clipEdges(useSafeArea: false)
        
        middleView.clipRight(to: .right, margin: 12)
        middleView.clipLeft(to: .left, margin: 12)
        
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
            doneButton.clipEdges(margin: UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12), exclude: [.top])
            doneButton.height(SFDimension(value: 48))
            middleView.clipBottom(to: .top, of: doneButton)
            middleView.height(SFDimension(value: 200))
        }
        
        closeButton.width(SFDimension(value: 32))
        closeButton.height(SFDimension(value: 32))
        closeButton.clipBottom(to: .top, of: middleView, margin: 12)
        closeButton.clipRight(to: .right, margin: 12)
        
        titleLabel.center(axis: [.horizontal])
        titleLabel.center(axis: [.vertical], in: closeButton)
        
        if useCompactInterface {
            backgroundView.width(SFDimension(type: .fraction, value: 11/12))
            backgroundView.clipCenterX(to: .centerX)
        } else {
            backgroundView.width(SFDimension(type: .fraction, value: 1/2))
            backgroundView.clipCenterX(to: .centerX)
        }
        
        backgroundView.clipBottom(to: .bottom, margin: 12)
        backgroundView.clipTop(to: .top, of: closeButton, margin: -12)
        
        super.updateConstraints()
        
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        blurView.effect = colorStyle.getEffectStyle()
        updateSubviewsColors()
    }
}





















