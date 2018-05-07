//
//  SFPageView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 04/05/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPageView: SFScrollView {
    
    // MARK: - Instance Properties
    
    open var selectedIndex = 0
    open lazy var views: [UIView] = []
    open lazy var viewsStackView: SFStackView = {
        let stackView = SFStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        contentView.addSubview(viewsStackView)
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func configure(with views: [UIView]) {
        self.views = views
        views.enumerated().forEach { (index, view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = index % 2 == 0 ? UIColor.red : UIColor.blue
            viewsStackView.addArrangedSubview(view)
            view.width(SFDimension(type: .fraction, value: 1), comparedTo: self)
        }
    }
    
    open override func layoutIfBoundsChanged() {
        super.layoutIfBoundsChanged()
        viewsStackView.clipEdges(exclude: [.bottom])
        contentView.clipBottom(to: .bottom, of: viewsStackView)
    }
}





















