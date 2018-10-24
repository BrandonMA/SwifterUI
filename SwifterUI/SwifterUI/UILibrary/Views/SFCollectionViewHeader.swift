//
//  SFCollectionViewHeader.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 19/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFCollectionViewHeaderFooterView: UICollectionReusableView, SFViewColorStyle, SFLayoutView {
    
    // MARK: - Class Properties
    
    open class var height: CGFloat {
        return 32
    }
    
    open class var identifier: String {
        return "SFCollectionHeaderView"
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
        addSubview(titleLabel)
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    open func setConstraints() {
        titleLabel.clipSides(margin: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }

    open func updateColors() {
        backgroundColor = .clear
        updateSubviewsColors()
    }
    
}

open class SFCollectionViewHeaderView: SFCollectionViewHeaderFooterView {
    
    // MARK: - Class Properties
    
    open override class var identifier: String {
        return "SFCollectionViewHeaderView"
    }
    
}

open class SFCollectionViewFooterView: SFCollectionViewHeaderFooterView {
    
    // MARK: - Class Properties
    
    open override class var identifier: String {
        return "SFCollectionViewFooterView"
    }
    
}
