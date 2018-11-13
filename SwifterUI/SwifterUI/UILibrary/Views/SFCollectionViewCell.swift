//
//  SFCollectionViewCell.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFCollectionViewCell: UICollectionViewCell, SFViewColorStyle, SFLayoutView {
    
    // MARK: - Class Properties
    
    open class var identifier: String {
        return "SFCollectionViewCell"
    }
    
    // MARK: - Instance Properties
    
    open var customConstraints: Constraints = []
    
    open var automaticallyAdjustsColorStyle: Bool = true
    
    open var useAlternativeColors: Bool = false
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubviews()
        setConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func prepareSubviews() {
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    open func setConstraints() {
        
    }
    
    open func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.alternativeColor : colorStyle.mainColor
        updateSubviewsColors()
    }
    
    public func updateSubviewsColors() {
        for view in self.contentView.subviews {
            if let subview = view as? SFViewColorStyle {
                if subview.automaticallyAdjustsColorStyle == true {
                    subview.updateColors()
                }
            }
        }
    }
    
}
