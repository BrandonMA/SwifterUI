//
//  SFPopBar.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSlideBar: SFView {
    
    // MARK: - Instance Properties
    
    open lazy var dismissButton: SFFluidButton = {
        let button = SFFluidButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView.image = SFAssets.imageOfArrowDown.withRenderingMode(.alwaysTemplate)
        button.useAlternativeColors = true
        return button
    }()
    
    open lazy var titleLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    open lazy var rightButton: SFFluidButton = {
        let button = SFFluidButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel.textAlignment = .right
        button.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.useAlternativeColors = true
        return button
    }()
    
    // MARK: - Initializers
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        addSubview(dismissButton)
        addSubview(titleLabel)
        addSubview(rightButton)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        dismissButton.clipCenterY(to: .centerY, margin: 2)
        dismissButton.clipLeft(to: .left, margin: 12)
        dismissButton.width(SFDimension(value: 32))
        dismissButton.height(SFDimension(value: 32))
        titleLabel.center()
        
        rightButton.clipCenterY(to: .centerY)
        rightButton.clipRight(to: .right, margin: 16)
        rightButton.height(SFDimension(value: 32))
        rightButton.clipLeft(to: .right, of: titleLabel)
        
        super.setConstraints()
    }
    
    open override func updateColors() {
        super.updateColors()
        addShadow(color: colorStyle.getSeparatorColor(), offSet: CGSize(width: 0, height: 1), radius: 0, opacity: 1)
    }
    
    open override func updateConstraints() {
        
        if customConstraints.isEmpty {
            customConstraints.append(height(SFDimension(value: 44)))
        }
        
        super.updateConstraints()
    }
}

