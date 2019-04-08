//
//  SFPopView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 07/09/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPopView: SFView {
    
    // MARK: - Instance Properties
    
    public final lazy var shadowView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.alpha = 0.5
        view.backgroundColor = .black
        return view
    }()
    
    open lazy var contentView: SFView = {
        let view = SFView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.layer.cornerRadius = 16
        view.addShadow(color: .black, offSet: CGSize(width: 0, height: 12), radius: 16, opacity: 0.15)
        return view
    }()
    
    open var middleView: UIView
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero, middleView: UIView) {
        self.middleView = middleView
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        addSubview(shadowView)
        addSubview(contentView)
        contentView.addSubview(middleView)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        
        shadowView.clipSides(useSafeArea: false)
        
        middleView.clipRight(to: .right, margin: 12)
        middleView.clipLeft(to: .left, margin: 12)
        
        contentView.clipTop(to: .top, of: middleView, margin: 12)
        contentView.clipBottom(to: .bottom, of: middleView, margin: 12)
        contentView.center()
        
        super.setConstraints()
    }
    
    open override func updateConstraints() {
        
        contentView.removeConstraint(type: .width)
        
        if useCompactInterface {
            contentView.setWidth(SFDimension(type: .fraction, value: 11/12))
        } else {
            contentView.setWidth(SFDimension(type: .fraction, value: 1/2))
        }
        
        super.updateConstraints()
        
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        updateSubviewsColors()
    }
    
}
