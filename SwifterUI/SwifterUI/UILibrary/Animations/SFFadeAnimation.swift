//
//  SFFadeAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit

open class SFFadeAnimation: SFAnimation {
    
    // MARK: - Instance Methods
    
    open override func load() {
        initialAlpha = self.type == .inside ? 0.0 : 1.0
        finalAlpha = self.type == .inside ? 1.0 : 0.0
    }
    
    @discardableResult
    open override func start() -> Promise<Void> {
        return Promise { seal in
            guard let view = view else {
                seal.reject(SFAnimationError.noParent)
                return
            }
            view.frame = initialFrame
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: [animationCurve.getAnimationOptions(), .allowUserInteraction], animations: {
                view.alpha = self.finalAlpha
            }, completion: { finished in
                seal.fulfill(())
            })
        }
    }
}
