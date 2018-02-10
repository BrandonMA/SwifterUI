//
//  SFButton.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 06/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFButton: UIButton, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var shouldUseAlternativeColors: Bool = false
    
    open var shouldUseAlternativeTextColor: Bool = false
    
    lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(frame: .zero)
        addSubview(rightImageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        rightImageView.clipEdges(margin: ConstraintMargin(top: 8, right: 8, bottom: 8, left: 0), exclude: [.left])
        rightImageView.width(SFDimension(value: 14))
        super.layoutSubviews()
    }
    
    open func updateColors() {
        backgroundColor = shouldUseAlternativeColors == true ? colorStyle.getTextEntryColor() : colorStyle.getAlternativeColors()
        tintColor = shouldUseAlternativeTextColor == true ? colorStyle.getPlaceholderColor() : colorStyle.getInteractiveColor()
        if shouldUseAlternativeTextColor == true {
            setTitleColor(colorStyle.getPlaceholderColor(), for: .normal)
        } else {
            setTitleColor(colorStyle.getInteractiveColor(), for: .normal)
        }
        updateSubviewsColors()
    }
    
}
