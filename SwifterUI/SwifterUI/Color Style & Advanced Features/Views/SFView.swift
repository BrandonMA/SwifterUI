//
//  SFView.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 25/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

@IBDesignable open class SFView: UIView, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var shouldHaveAlternativeColors: Bool = false
    
    // MARK: - Initializers
    
    public required init(automaticallyAdjustsColorStyle: Bool = true) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        backgroundColor = shouldHaveAlternativeColors == true ? colorStyle.getAlternativeColors() : colorStyle.getMainColor()
        updateSubviewsColors()
    }
    
}
