//
//  UITextView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 01/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UITextView {
    
    // MARK: - Instance Methods
    
    // Use this function to update height constraint automatically, just call it whenever the user trype something
    public func updateHeightConstraint() {
        let sizeThatFitsTextView = sizeThatFits(CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT)))
        if frame.size.height < sizeThatFitsTextView.height {
            get(constraintType: .height)?.constant = sizeThatFitsTextView.height
        }
    }
    
}
