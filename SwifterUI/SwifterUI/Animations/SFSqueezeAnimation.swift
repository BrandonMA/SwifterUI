//
//  SFSqueezeAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSqueezeAnimation: SFAnimation {
    
    // MARK: - Instance Methods
    
    open override func start() {
        guard let view = self.view else { return }
        CATransaction.begin()
        CATransaction.setCompletionBlock({ self.delegate?.finished(animation: self) })
        
        let squeezeX = CAKeyframeAnimation()
        squeezeX.keyPath = "transform.scale.x"
        squeezeX.values = [1, 1.5*force, 0.5, 1.5*force, 1]
        squeezeX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        squeezeX.timingFunction = animationCurve.getTimingFunction()
        squeezeX.duration = CFTimeInterval(duration)
        squeezeX.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        view.layer.add(squeezeX, forKey: "squeezeX")
        
        let squeezeY = CAKeyframeAnimation()
        squeezeY.keyPath = "transform.scale.y"
        squeezeY.values = [1, 0.5, 1, 0.5, 1]
        squeezeY.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        squeezeY.timingFunction = animationCurve.getTimingFunction()
        squeezeY.duration = CFTimeInterval(duration)
        squeezeY.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        view.layer.add(squeezeY, forKey: "squeezeY")
        
        CATransaction.commit()
    }
}
