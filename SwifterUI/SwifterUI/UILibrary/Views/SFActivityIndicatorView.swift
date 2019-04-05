//
//  SFActivityIndicatorView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/25/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFActivityIndicatorView: UIActivityIndicatorView, SFViewColorStyle, SFLayoutView {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var useAlternativeColors: Bool = false // Not used by the class itslef
    
    open var customConstraints: Constraints = []
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, style: UIActivityIndicatorView.Style = .gray, frame: CGRect = .zero) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(style: style)
        prepareSubviews()
        setConstraints()
    }
    
    required public init(coder: NSCoder) {
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
        backgroundColor = .clear
        style = colorStyle.activityIndicatorStyle
        updateSubviewsColors()
    }
    
}
