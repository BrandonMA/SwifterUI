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
    
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 64
        imageView.image = SFAssets.imageOfBigPlus.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .center
        return imageView
    }()
    
    open lazy var closeButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22
        button.setImage(SFAssets.imageOfCancelIcon, for: .normal)
        button.useAlternativeColors = true
        button.addShadow(color: .black, offSet: CGSize(width: 0, height: 2), radius: 6, opacity: 0.05)
        return button
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        addSubview(imageView)
        addSubview(closeButton)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.clipTop(to: .top)
        imageView.clipCenterX(to: .centerX)
        imageView.width(SFDimension(value: 128))
        imageView.height(SFDimension(value: 128))
        
        closeButton.clipCenterX(to: .centerX)
        closeButton.clipCenterY(to: .bottom, of: imageView)
        closeButton.width(SFDimension(value: 44))
        closeButton.height(SFDimension(value: 44))
    }
    
    open override func updateColors() {
        super.updateColors()
        imageView.backgroundColor = useAlternativeColors ? colorStyle.getTextEntryColor() : colorStyle.getAlternativeColor()
        imageView.tintColor = colorStyle.getPlaceholderColor()
    }
}


















