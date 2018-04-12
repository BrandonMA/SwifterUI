//
//  SFStackView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 12/04/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFStackView: UIStackView, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = true
    
    open var useAlternativeColors: Bool = false
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        updateSubviewsColors()
    }
    
}
