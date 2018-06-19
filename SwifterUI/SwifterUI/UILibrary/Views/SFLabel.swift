//
//  SFLabel.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFLabel: UILabel, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var useAlternativeColors: Bool = false
    
    open var useClearBackground: Bool = false
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        self.useAlternativeColors = useAlternativeColors
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        if useClearBackground == false {
            if let superview = superview as? SFViewColorStyle {
                backgroundColor = superview.useAlternativeColors ? colorStyle.getAlternativeColor() : colorStyle.getMainColor()
            } else {
                backgroundColor = colorStyle.getMainColor()
            }
        } else {
            backgroundColor = .clear
        }
        textColor = useAlternativeColors ? colorStyle.getPlaceholderColor() : colorStyle.getTextColor()
        updateSubviewsColors()
    }
    
}
