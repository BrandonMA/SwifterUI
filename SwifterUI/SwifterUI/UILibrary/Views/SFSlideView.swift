//
//  SFPopView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSlideView: SFView {
    
    // MARK: - Instance Properties
    
    open lazy var bar: SFSlideBar = {
        let bar = SFSlideBar(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        return bar
    }()
    
    open lazy var contentView: SFView = {
        let view = SFView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, useAlternativeColors: self.useAlternativeColors)
        return view
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        addSubview(bar)
        addSubview(contentView)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        bar.clipSides(exclude: [.bottom], useSafeArea: false)
        contentView.clipSides(exclude: [.top])
        contentView.clipTop(to: .bottom, of: bar)
        super.setConstraints()
    }
}

