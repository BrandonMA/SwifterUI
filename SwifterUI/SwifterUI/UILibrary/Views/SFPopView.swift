//
//  SFPopView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPopView: SFView {
    
    // MARK: - Instance Properties
    
    open lazy var bar: SFPopBar = {
        let bar = SFPopBar(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    open lazy var contentView: SFView = {
        let view = SFView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, useAlternativeColors: self.useAlternativeColors)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool, useAlternativeColors: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        clipsToBounds = true
        addSubview(bar)
        addSubview(contentView)
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func updateConstraints() {
        bar.clipEdges(exclude: [.bottom], useSafeArea: false)
        contentView.clipEdges(exclude: [.top])
        contentView.clipTop(to: .bottom, of: bar)
        super.updateConstraints()
    }
}

