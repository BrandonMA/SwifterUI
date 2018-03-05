//
//  SFPopAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPopAnimation: SFAnimation {
    
    // MARK: - Instance Methods
    
    open override func load() {
        self.initialScaleX = type == .outside ? 1 + force * 0.2 : force * 0.2 < 1 ? 1 - force * 0.2 : 0
        self.finalScaleX = type == .outside ? force * 0.2 < 1 ? 1 - force * 0.2 : 0 : 1 + force * 0.2
    }
    
    open override func start() {
        guard let view = self.view else { return }
        CATransaction.begin()
        CATransaction.setCompletionBlock({ self.delegate?.finished(animation: self) })
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
