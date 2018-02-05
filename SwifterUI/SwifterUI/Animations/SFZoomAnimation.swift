//
//  SFZoomAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFZoomAnimation: SFAnimation {
    
    // MARK: - Instance Methods
    
    open override func load() {
        guard let view = self.view else { return }
        initialScaleX = type == .inside ? 1.5 : 1.0
        initialScaleY = type == .inside ? 1.5 : 1.0
        finalScaleX = type == .inside ? 1.0 : 1.5
        finalScaleY = type == .inside ? 1.0 : 1.5
        initialAlpha = type == .inside ? 0.0 : 1.0
        finalAlpha = type == .inside ? 1.0 : 0.0
        initialFrame = view.frame
        view.transform = CGAffineTransform(scaleX: initialScaleX, y: initialScaleY)
    }
    
    open override func start() {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: [animationCurve.getAnimationOptions(), .allowUserInteraction], animations: {
            self.view?.transform = CGAffineTransform(scaleX: self.finalScaleX, y: self.finalScaleY)
            self.view?.alpha = self.finalAlpha
        }, completion: { finished in
            self.delegate?.didFinishAnimation()
        })
    }
}

