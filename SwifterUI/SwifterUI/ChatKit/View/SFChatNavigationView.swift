//
//  SFChatNavigationView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/15/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFChatNavigationView: SFView {
    
    // MARK: - Instance Properties
    
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    open lazy var nameButton: SFFluidButton = {
        let button = SFFluidButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, useAlternativeColors: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        return button
    }()
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        addSubview(imageView)
        addSubview(nameButton)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        imageView.width(SFDimension(value: 32))
        imageView.height(SFDimension(value: 32))
        imageView.clipCenterY(to: .centerY)
        imageView.clipLeft(to: .left)
        nameButton.clipSides(exclude: [.left], margin: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8))
        nameButton.clipLeft(to: .right, of: imageView, margin: 16)
        super.setConstraints()
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        updateSubviewsColors()
    }
    
}
