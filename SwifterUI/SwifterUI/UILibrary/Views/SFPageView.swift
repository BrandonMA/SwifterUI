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
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        contentView.addSubview(viewsStackView)
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    public final func add(view: UIView) {
        views.append(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        viewsStackView.addArrangedSubview(view)
        view.width(SFDimension(type: .fraction, value: 1), comparedTo: self)
    }
    
    public final func add(views: [UIView]) {
        views.forEach({ add(view: $0) })
    }
    
    open override func layoutIfBoundsChanged() {
        super.layoutIfBoundsChanged()
        viewsStackView.clipEdges(exclude: [.bottom])
        contentView.clipBottom(to: .bottom, of: viewsStackView)
    }
}





















