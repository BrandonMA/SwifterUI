//
//  SFWobbleAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFWobbleAnimation: SFAnimation {
    
    // MARK: - Instance Properties
    
    open var rotation: CGFloat = 0.1
    
    // MARK: - Instance Methods
    
    open override func load() {
        super.load()
        animationCurve = .easeOut
    }
    
    open override func start() {
        guard let view = self.view else { return }
        CATransaction.begin()
        CATransaction.setCompletionBlock({ self.delegate?.finished(animation: self) })
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.values = [0, rotation * force, -rotation * force, rotation * force, 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animation.duration = CFTimeInterval(duration)
        animation.isAdditive = true
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        animation.timingFunction = animationCurve.getTimingFunction()
        view.layer.add(animation, forKey: nil)
        CATransaction.commit()
    }
    
}
