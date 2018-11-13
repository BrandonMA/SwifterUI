//
//  SFTextField.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 06/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTextField: UITextField, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var useAlternativeColors: Bool = false
    
    public var leftPadding: CGFloat = 0 {
        didSet {
            updateLeftView()
        }
    }
    
    public var leftImageSize: CGSize = .zero {
        didSet {
            updateLeftView()
        }
    }
    
    public var leftImage: UIImage? = nil {
        didSet {
            updateLeftView()
        }
    }
    
    public var rightPadding: CGFloat = 0 {
        didSet {
            updateRightView()
        }
    }
    
    public var rightImageSize: CGSize = .zero {
        didSet {
            updateRightView()
        }
    }
    
    public var rightImage: UIImage? = nil {
        didSet {
            updateRightView()
        }
    }
    
    private func updateLeftView() {
        var size = leftImageSize == .zero && leftImage != nil ? CGSize(width: 16, height: 16) : leftImageSize
        size.width = leftImage != nil ? size.width + leftPadding * 2 : size.width + leftPadding
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: size))
        imageView.contentMode = .scaleAspectFit
        imageView.image = leftImage
        leftView = imageView
        leftViewMode = .always
    }
    
    private func updateRightView() {
        var size = rightImageSize == .zero && rightImage != nil ? CGSize(width: 16, height: 16) : rightImageSize
        size.width = rightImage != nil ? size.width + rightPadding * 2 : size.width + rightPadding
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: size))
        imageView.contentMode = .scaleAspectFit
        imageView.image = rightImage
        rightView = imageView
        rightViewMode = .always
    }
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        self.useAlternativeColors = useAlternativeColors
        super.init(frame: frame)
        
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.contrastColor : colorStyle.alternativeColor
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: colorStyle.placeholderColor])
        }
        textColor = colorStyle.textColor
        keyboardAppearance = colorStyle.keyboardStyle
        updateSubviewsColors()
    }
    
}
