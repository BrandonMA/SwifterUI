//
//  SFCollectionViewCell.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFCollectionViewCell: UICollectionViewCell, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = true
    
    open var useAlternativeColors: Bool = false
    
    // MARK: - Initializers
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.getAlternativeColor() : colorStyle.getMainColor()
        updateSubviewsColors()
    }
    
}
