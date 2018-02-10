//
//  SFDisplayNodeColorStyleProtocol.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 28/08/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFViewColorStyle: SFColorStyleProtocol {
    
    // shouldHaveAlternativeColors: Indicates whether it should use getAlternativeBackgroundColor or getBackgroundColor
    var shouldHaveAlternativeColors: Bool { get set }
    
}

public extension SFViewColorStyle where Self: UIView {
    
    // MARK: - Instance Methods
    
    // updateSubNodesColors: This implementation of updateSubNodesColors loop over all subnodes and call updateColors()
    public func updateSubviewsColors() {
        for view in self.subviews {
            if let subview = view as? SFViewColorStyle {
                if subview.automaticallyAdjustsColorStyle == true {
                    UIView.animate(withDuration: 0.5, animations: {
                        subview.updateColors()
                    })
                }
            }
        }
    }
}

