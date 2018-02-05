//
//  SFMargin.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public struct ConstraintMargin {
    public var top: CGFloat
    public var right: CGFloat
    public var bottom: CGFloat
    public var left: CGFloat
    public static var zero: ConstraintMargin = ConstraintMargin()
    
    public init(top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0) {
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left
    }
    
    public init(with value: CGFloat) {
        self.init(top: value, right: value, bottom: value, left: value)
    }
}
