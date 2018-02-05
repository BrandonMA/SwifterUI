//
//  UITextView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 01/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UITextView {
    
    public func updateHeightConstraint() {
        let sizeThatFitsTextView = sizeThatFits(CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT)))
        if frame.size.height < sizeThatFitsTextView.height {
            get(constraintType: .height)?.constant = sizeThatFitsTextView.height
        }
    }
    
}
