//
//  SFDatePicker.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 16/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFDatePicker: UIDatePicker, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var useAlternativeColors: Bool = false
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(frame: frame)
        updateColors()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        backgroundColor = colorStyle.getMainColor()
        setValue(colorStyle.getTextColor(), forKeyPath: "textColor")
        setValue(false, forKeyPath: "highlightsToday")
        if subviews.count >= 2 {
            subviews[1].backgroundColor = colorStyle.getSeparatorColor()
            subviews[2].backgroundColor = colorStyle.getSeparatorColor()
        }
    }
    
}
