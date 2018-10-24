//
//  ProfileImageView.swift
//  WhatsDoc
//
//  Created by brandon maldonado alonso on 26/02/18.
//  Copyright © 2018 brandon maldonado alonso. All rights reserved.
//

import UIKit

open class SFProfileImageView: SFView {
    
    // MARK: - Instance Properties
    
    open var image: UIImage? = nil {
        didSet {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = SFAssets.imageOfBigPlus.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    open lazy var closeButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, useAlternativeColors: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22
        button.setImage(SFAssets.imageOfCancelIcon, for: .normal)
        button.addShadow(color: .black, offSet: CGSize(width: 0, height: 2), radius: 6, opacity: 0.10)
        button.addTouchAnimations = true
        return button
    }()
    
    // MARK: - Initializers
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        addSubview(imageView)
        addSubview(closeButton)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        imageView.clipTop(to: .top)
        imageView.clipCenterX(to: .centerX)
        imageView.width(SFDimension(value: 128))
        imageView.height(SFDimension(value: 128))
        
        closeButton.clipCenterX(to: .centerX)
        closeButton.clipCenterY(to: .bottom, of: imageView)
        closeButton.width(SFDimension(value: 44))
        closeButton.height(SFDimension(value: 44))
        
        clipRight(to: .right, of: imageView)
        clipBottom(to: .bottom, of: closeButton)
        clipLeft(to: .left, of: imageView)
        super.setConstraints()
    }
    
    open override func updateConstraints() {
        imageView.layer.cornerRadius = 64
        super.updateConstraints()
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        imageView.backgroundColor = useAlternativeColors ? colorStyle.getContrastColor() : colorStyle.getAlternativeColor()
        imageView.tintColor = colorStyle.getPlaceholderColor()
        updateSubviewsColors()
    }
    
    open func removeImage() {
        imageView.image = SFAssets.imageOfBigPlus.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .center
    }
}
