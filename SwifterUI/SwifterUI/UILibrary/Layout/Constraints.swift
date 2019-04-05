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

    func activate() {
        Constraint.activate(self)
    }

    func deactivate() {
        Constraint.deactivate(self)
    }
    
    func forEachConstraint(where view: UIView, completion: @escaping (Constraint) -> Void) {
        forEach { (constraint) in
            if let firstItem = constraint.firstItem as? UIView, firstItem == view {
                completion(constraint)
            }
        }
    }
}
