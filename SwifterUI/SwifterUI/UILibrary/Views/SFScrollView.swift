//
//  SFScrollView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 18/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFScrollView: UIScrollView, SFViewColorStyle, SFLayoutView {
    
    // MARK: - Instance Properties
    
    open var needsLayoutUpdate: Bool = true
    
    open var customConstraints: Constraints = []
    
    private var oldSize: CGSize = .zero
    
    open override var bounds: CGRect {
        didSet {
            if oldSize == .zero {
                oldSize = bounds.size
                needsLayoutUpdate = true
            } else {
                if oldSize != bounds.size {
                    oldSize = bounds.size
                    needsLayoutUpdate = true
                } else {
                    needsLayoutUpdate = false
                }
            }
        }
    }
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var useAlternativeColors: Bool = false {
        didSet {
            self.contentView.useAlternativeColors = useAlternativeColors
        }
    }
    
    open var scrollsHorizontally: Bool = true
    
    open var scrollVertically: Bool = true
    
    open lazy var contentView: SFView = {
        let view = SFView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, useAlternativeColors: self.useAlternativeColors)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        addSubview(contentView)
        
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    open func setConstraints() {
        customConstraints.append(contentsOf: contentView.clipSides(useSafeArea: false))
    }
    
    open func layoutIfBoundsChanged() {
        
        if scrollsHorizontally == false {
            contentView.setWidth(SFDimension(type: .fraction, value: 1))
        }
        
        if scrollVertically == false {
            contentView.setHeight(SFDimension(type: .fraction, value: 1))
        }
    }
    
    open override func updateConstraints() {
        
        if needsLayoutUpdate {
            layoutIfBoundsChanged()
        }
        
        super.updateConstraints()
    }
    
    open func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.alternativeColor : colorStyle.mainColor
        updateSubviewsColors()
    }
    
}
