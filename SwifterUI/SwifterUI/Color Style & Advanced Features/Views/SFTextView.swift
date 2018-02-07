//
//  SFTextView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 06/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTextView: UITextView, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var shouldHaveAlternativeColors: Bool = false
    
    // MARK: - Initializers
    
    public required init(automaticallyAdjustsColorStyle: Bool = true) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(frame: .zero, textContainer: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        backgroundColor = shouldHaveAlternativeColors == true ? colorStyle.getAlternativeColors() : colorStyle.getTextEntryColor()
        updateSubviewsColors()
    }
    
}
