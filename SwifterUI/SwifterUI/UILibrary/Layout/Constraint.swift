//
//  Constraint.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public typealias Constraint = NSLayoutConstraint

public extension Constraint {
    
    @discardableResult
    final func set(identifier: String) -> Self {
        self.identifier = identifier
        return self
    }
    
    @discardableResult
    final func set(active: Bool) -> Self {
        self.isActive = active
        return self
    }
}
