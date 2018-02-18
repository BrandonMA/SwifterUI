//
//  SFSection.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSection: SFView {
    
    // MARK: - Instance Properties
    
    open lazy var titleLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    open lazy var bottomView: UIView = UIView()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        addSubview(titleLabel)
        addSubview(bottomView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        titleLabel.clipEdges(exclude: [.bottom])
        bottomView.height(SFDimension(value: 34))
        bottomView.clipEdges(exclude: [.top, .bottom])
        bottomView.clipTop(to: .bottom, of: titleLabel, margin: 8)
        clipBottom(to: .bottom, of: bottomView)
        super.layoutSubviews()
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        updateSubviewsColors()
    }
}
