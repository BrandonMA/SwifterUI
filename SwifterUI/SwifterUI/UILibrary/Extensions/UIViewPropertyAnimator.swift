//
//  UIViewPropertyAnimator.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/19/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIViewPropertyAnimator {
    
    convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let timingParameters = UISpringTimingParameters(damping: damping, response: response, initialVelocity: initialVelocity)
        self.init(duration: 0, timingParameters: timingParameters)
    }
    
}
