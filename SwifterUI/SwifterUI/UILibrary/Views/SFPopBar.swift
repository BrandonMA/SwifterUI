//
//  SFPopBar.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPopBar: SFView {
    
    // MARK: - Instance Properties
    
    open override var tintColor: UIColor! {
        didSet {
            dismissButton.tintColor = tintColor
        }
    }
    
    open lazy var dismissButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.useAlternativeColors = true
        button.setImage(SFAssets.imageOfArrowDown.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTouchAnimations = true
        return button
    }()
    
    open lazy var titleLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    open lazy var rightButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.useAlternativeColors = true
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.addTouchAnimations = true
        return button
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        addSubview(dismissButton)
        addSubview(titleLabel)
        addSubview(rightButton)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func updateConstraints() {
        dismissButton.center(axis: [.y])
        dismissButton.clipLeft(to: .left, margin: 12)
        dismissButton.width(SFDimension(value: 32))
        dismissButton.height(SFDimension(value: 32))
        titleLabel.center()
        
        rightButton.clipCenterY(to: .centerY)
        rightButton.clipRight(to: .right, margin: 16)
        rightButton.height(SFDimension(value: 32))
        rightButton.clipLeft(to: .right, of: titleLabel)
        
        height(SFDimension(value: 44))
        super.updateConstraints()
    }
    
    open override func updateColors() {
        super.updateColors()
        self.tintColor = colorStyle.getInteractiveColor()
        addShadow(color: colorStyle.getSeparatorColor(), offSet: CGSize(width: 0, height: 1), radius: 0, opacity: 1)
    }
    
}

