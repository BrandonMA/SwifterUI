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
    
    open var useAlternativeColors: Bool = false
        
    open var setTextColor: Bool = true
    
    open var useAlternativeTextColor: Bool = false
    
    open var useClearColor: Bool = false
    
    lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(frame: frame)
        addSubview(rightImageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        rightImageView.clipEdges(margin: ConstraintMargin(top: 8, right: 8, bottom: 8, left: 0), exclude: [.left], useSafeArea: false)
        rightImageView.width(SFDimension(value: 14))
    }
    
    open func updateColors() {
        backgroundColor = useClearColor ? .clear : useAlternativeColors ? colorStyle.getMainColor() : colorStyle.getAlternativeColor()
        if setTextColor {
            if useAlternativeTextColor {
                tintColor = colorStyle.getPlaceholderColor()
                setTitleColor(colorStyle.getPlaceholderColor(), for: .normal)
            } else {
                tintColor = colorStyle.getInteractiveColor()
                setTitleColor(colorStyle.getInteractiveColor(), for: .normal)
            }
        }
        updateSubviewsColors()
    }
    
}
