//
//  SFFadeAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFFadeAnimation: SFAnimation {
    
    // MARK: - Instance Methods
    
    open override func load() {
        initialAlpha = self.type == .inside ? 0.0 : 1.0
        finalAlpha = self.type == .inside ? 1.0 : 0.0
    }
    
    open override func start() {
        guard let view = self.view else { return }
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: [animationCurve.getAnimationOptions(), .allowUserInteraction], animations: {
            view.alpha = self.finalAlpha
        }, completion: { finished in
            self.delegate?.didFinishAnimation()
        })
    }
}
