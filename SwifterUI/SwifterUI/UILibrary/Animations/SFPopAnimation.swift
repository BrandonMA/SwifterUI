//
//  SFPopAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit

open class SFPopAnimation: SFAnimation {
    
    // MARK: - Instance Methods
    
    open override func load() {
        self.initialScaleX = type == .outside ? 1 + force * 0.2 : force * 0.2 < 1 ? 1 - force * 0.2 : 0
        self.finalScaleX = type == .outside ? force * 0.2 < 1 ? 1 - force * 0.2 : 0 : 1 + force * 0.2
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
            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.values = [1, initialScaleX, finalScaleX, initialScaleX, 1]
            animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            animation.timingFunction = animationCurve.getTimingFunction()
            animation.duration = self.duration
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            view.layer.add(animation, forKey: nil)
            CATransaction.commit()
        }
    }
}
