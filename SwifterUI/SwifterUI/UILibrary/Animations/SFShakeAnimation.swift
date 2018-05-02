//
//  SFShakeAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit

open class SFShakeAnimation: SFAnimation {
    
    // MARK: - Instance Methods
    
    open override func load() {
        guard let view = view else { return }
        self.initialFrame = view.frame
    }
    
    @discardableResult
    open override func start() -> Promise<Void> {
        return Promise { seal in
            guard let view = view else {
                seal.reject(SFAnimationError.noParent)
                return
            }
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                seal.fulfill(())
            })
            let animation = CAKeyframeAnimation(keyPath: "position.x")
            let modifier = 30 * force
            animation.values = [initialFrame.midX, initialFrame.midX + modifier, initialFrame.midX, initialFrame.midX - modifier, initialFrame.midX + modifier, initialFrame.midX]
            animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            animation.timingFunction = animationCurve.getTimingFunction()
            animation.duration = duration
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            view.layer.add(animation, forKey: nil)
            CATransaction.commit()
        }
    }
}
