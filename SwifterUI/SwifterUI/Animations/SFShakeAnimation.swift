//
//  SFShakeAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFShakeAnimation: SFAnimation {
    
    // MARK: - Instance Methods
    
    open override func load() {
        guard let view = view else { return }
        self.initialFrame = view.frame
    }
    
    open override func start() {
        guard let view = view else { return }
        CATransaction.begin()
        CATransaction.setCompletionBlock({ self.delegate?.finished(animation: self) })
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
