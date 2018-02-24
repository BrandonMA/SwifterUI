//
//  SFScrollView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 18/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFScrollView: UIScrollView, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var needsLayoutUpdate: Bool = true
    
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
        let view = SFView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(frame: frame)
        addSubview(contentView)
        contentView.clipEdges(useSafeArea: false) // Don't move this line to layoutSubviews because automatic scrolling is not going to work, not sure why.
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func layoutIfBoundsChanged() {
        clipEdges(useSafeArea: false)
        
        if scrollsHorizontally == false {
            contentView.width(SFDimension(type: .fraction, value: 1), comparedTo: superview)
        }
        
        if scrollVertically == false {
            contentView.height(SFDimension(type: .fraction, value: 1), comparedTo: superview)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if needsLayoutUpdate {
            layoutIfBoundsChanged()
        }
    }
    
    open func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.getAlternativeColors() : colorStyle.getMainColor()
        updateSubviewsColors()
    }
    
}
