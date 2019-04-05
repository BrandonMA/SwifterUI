//
//  SFPickerView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 16/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPickerView: UIPickerView, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var useAlternativeColors: Bool = false
    
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
        reloadAllComponents()
        backgroundColor = colorStyle.mainColor
        if subviews.count >= 2 {
            subviews[1].backgroundColor = colorStyle.separatorColor
            subviews[2].backgroundColor = colorStyle.separatorColor
        }
    }
    
}
