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
    
    lazy var bar: SFPopBar = {
        let bar = SFPopBar(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        useAlternativeColors = true
        clipsToBounds = true
        addSubview(bar)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        bar.clipEdges(exclude: [.bottom])
        super.layoutSubviews()
    }
    
}
