//
//  SFCollectionViewHeader.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 19/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFCollectionViewHeaderFooterView: UICollectionReusableView, SFViewColorStyle, SFMainContainer {
    
    // MARK: - Class Properties
    
    open class var height: CGFloat {
        return 32
    }
    
    open class var identifier: String {
        return "SFCollectionHeaderView"
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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
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


























