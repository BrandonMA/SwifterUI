//
//  SFView.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 25/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFView: UIView, SFViewColorStyle, SFLayoutView {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle = false
    
    open var useAlternativeColors = false
    
    open var customConstraints: Constraints = []
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        self.useAlternativeColors = useAlternativeColors
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
    
    open func setConstraints() {}
    
    open func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.alternativeColor : colorStyle.mainColor
        updateSubviewsColors()
    }

    open override func addSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        super.addSubview(view)
    }
}
