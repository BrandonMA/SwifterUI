//
//  SFRotationAnimation.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 04/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFRotationAnimation: SFAnimation {
    
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
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = CFTimeInterval(duration)
        animation.isAdditive = true
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        animation.timingFunction = animationCurve.getTimingFunction()
        view.layer.add(animation, forKey: nil)
        CATransaction.commit()
    }
}
