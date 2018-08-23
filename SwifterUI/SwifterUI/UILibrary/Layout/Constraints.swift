//
//  Constraints.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public typealias Constraints = [Constraint]

public extension Array where Element: Constraint {

    public func activate() {
        Constraint.activate(self)
    }

    public func deactivate() {
        Constraint.deactivate(self)
    }
}
