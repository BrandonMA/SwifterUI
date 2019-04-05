//
//  SFDisplayNodeColorStyleProtocol.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 28/08/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFViewColorStyle: SFColorStyleProtocol {
    
    // MARK: - Instance Properties
    
    /**
     Indicates whether it should use getAlternativeBackgroundColor or getBackgroundColor
     */
    var useAlternativeColors: Bool { get set }
    
}

public extension SFViewColorStyle where Self: UIView {
    
    // MARK: - Instance Methods
    
    func updateSubviewsColors() {
        for view in self.subviews {
            if let subview = view as? SFViewColorStyle {
                if subview.automaticallyAdjustsColorStyle == true {
                    subview.updateColors()
                }
            }
        }
    }
}
