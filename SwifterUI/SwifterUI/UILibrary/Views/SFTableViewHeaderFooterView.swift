//
//  SFTableHeaderView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 04/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTableViewHeaderFooterView: UITableViewHeaderFooterView, SFViewColorStyle, SFLayoutView {
    
    // MARK: - Class Properties
    
    open class var height: CGFloat {
        return 32
    }
    
    open class var identifier: String {
        return "SFTableHeaderView"
    }
    
    // MARK: - Instance Properties
    
    open var customConstraints: Constraints = []
    
    open var automaticallyAdjustsColorStyle: Bool = true
    
    open var useAlternativeColors: Bool = false
    
    open lazy var titleLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.boldSystemFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepareSubviews()
        setConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func prepareSubviews() {
        contentView.addSubview(titleLabel)
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    open func setConstraints() {
        titleLabel.clipSides(margin: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), useSafeArea: false)
    }
    
    open func updateColors() {
        if backgroundView != nil && backgroundView?.backgroundColor != nil {
            backgroundView?.backgroundColor = useAlternativeColors ? colorStyle.alternativeColor : colorStyle.mainColor
        }
        titleLabel.textColor = colorStyle.placeholderColor
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
