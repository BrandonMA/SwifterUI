//
//  SFCellView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 07/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

import UIKit

open class SFTableCellView: UITableViewCell, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var shouldHaveAlternativeColors: Bool = false
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required convenience init(automaticallyAdjustsColorStyle: Bool = true) {
        self.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, style: .subtitle, reuseIdentifier: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        backgroundColor = shouldHaveAlternativeColors == true ? colorStyle.getAlternativeColors() : colorStyle.getMainColor()
        textLabel?.textColor = colorStyle.getTextColor()
        detailTextLabel?.textColor = shouldHaveAlternativeColors == true ? colorStyle.getInteractiveColor() : colorStyle.getPlaceholderColor()
        updateSubviewsColors()
    }
    
}
