//
//  SFCollectionViewHeader.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 19/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFCollectionViewHeader: SFCollectionViewCell {
    
    // MARK: - Class Properties
    
    override open class var identifier: String {
        return "SFCollectionViewHeader"
    }
    
    // MARK: - Instance Properties
    
    open lazy var textLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.clipEdges(margin: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        updateSubviewsColors()
    }
    
}
