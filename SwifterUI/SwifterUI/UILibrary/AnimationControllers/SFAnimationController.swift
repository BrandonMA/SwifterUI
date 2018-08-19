//
//  SFAnimationController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 28/05/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    public let presenting: Bool
    
    public init(presenting: Bool) {
        self.presenting = presenting
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.0
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    }
    
    
}
