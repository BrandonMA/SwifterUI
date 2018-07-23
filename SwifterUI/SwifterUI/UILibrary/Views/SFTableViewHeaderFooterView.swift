//
//  SFTableHeaderView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 04/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTableViewHeaderFooterView: UITableViewHeaderFooterView, SFViewColorStyle, SFMainContainer {
    
    // MARK: - Class Properties
    
    open class var height: CGFloat {
        return 32
    }
    
    open class var identifier: String {
        return "SFTableHeaderView"
    }
    
    // MARK: - Instance Properties
    
    open var mainContraints: Constraints = []
    
    open var automaticallyAdjustsColorStyle: Bool = true
    
    open var useAlternativeColors: Bool = false
    
    open lazy var titleLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.useAlternativeColors = true
        return label
    }()
    
    // MARK: - Initializers
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.clipEdges(margin: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    open func updateColors() {
        if backgroundView != nil && backgroundView?.backgroundColor != nil {
            backgroundView?.backgroundColor = useAlternativeColors ? colorStyle.getAlternativeColor() : colorStyle.getMainColor()
        }
        titleLabel.textColor = colorStyle.getPlaceholderColor()
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


open class SFTableViewHeaderView: SFTableViewHeaderFooterView {
    
    // MARK: - Class Properties
    
    open override class var identifier: String {
        return "SFTableViewHeaderView"
    }
    
}

open class SFTableViewFooterView: SFTableViewHeaderFooterView {
    
    // MARK: - Class Properties
    
    open override class var identifier: String {
        return "SFTableViewFooterView"
    }
    
}
