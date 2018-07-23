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
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        addSubview(imageView)
        addSubview(closeButton)
        
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func updateConstraints() {
        
        if mainContraints.isEmpty {
            mainContraints.append(imageView.clipTop(to: .top))
            mainContraints.append(imageView.clipCenterX(to: .centerX))
            mainContraints.append(imageView.width(SFDimension(value: 128)))
            mainContraints.append(imageView.height(SFDimension(value: 128)))
            
            mainContraints.append(closeButton.clipCenterX(to: .centerX))
            mainContraints.append(closeButton.clipCenterY(to: .bottom, of: imageView))
            mainContraints.append(closeButton.width(SFDimension(value: 44)))
            mainContraints.append(closeButton.height(SFDimension(value: 44)))
            
            mainContraints.append(clipRight(to: .right, of: imageView))
            mainContraints.append(clipBottom(to: .bottom, of: closeButton))
            mainContraints.append(clipLeft(to: .left, of: imageView))
        }
        
        imageView.layer.cornerRadius = 64
        
        super.updateConstraints()
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        imageView.backgroundColor = useAlternativeColors ? colorStyle.getTextEntryColor() : colorStyle.getAlternativeColor()
        imageView.tintColor = colorStyle.getPlaceholderColor()
        updateSubviewsColors()
    }
    
    open func removeImage() {
        imageView.image = SFAssets.imageOfBigPlus.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .center
    }
}


















