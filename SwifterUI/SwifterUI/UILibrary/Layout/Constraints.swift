//
//  Constraints.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public typealias Constraints = [NSLayoutConstraint]

public extension Array where Element: Constraint {
    
    public func active() {
        Constraint.activate(self)
    }
    
    public func deactive() {
        Constraint.deactivate(self)
    }
}
