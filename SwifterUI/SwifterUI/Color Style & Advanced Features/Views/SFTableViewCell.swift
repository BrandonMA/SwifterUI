//
//  SFCellView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 07/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

import UIKit

open class SFTableViewCell: UITableViewCell, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var shouldHaveAlternativeColors: Bool = false
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        backgroundColor = shouldHaveAlternativeColors == true ? colorStyle.getAlternativeColors() : colorStyle.getMainColor()
        textLabel?.textColor = colorStyle.getTextColor()
        detailTextLabel?.textColor = shouldHaveAlternativeColors == true ? colorStyle.getInteractiveColor() : colorStyle.getPlaceholderColor()
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = shouldHaveAlternativeColors == true ? colorStyle.getMainColor() : colorStyle.getAlternativeColors()
        self.selectedBackgroundView = selectedBackgroundView
        updateSubviewsColors()
    }
    
}
