//
//  SFFlipAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFFlipAnimation: SFAnimation {
    
    public enum SFFlipType {
        case x
        case y
    }
    
    // MARK: - Instance Properties
    
    open var flipType: SFFlipType
    
    // MARK: - Initializers
    
    public init(with view: UIView, flipType: SFFlipType = .x) {
        self.flipType = flipType
        super.init(with: view, direction: .none, type: .none)
    }
    
    // MARK: - Instance Methods
    
    open override func start() {
        guard let view = self.view else { return }
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / view.layer.frame.size.width/2
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({ self.delegate?.finished(animation: self) })
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DMakeRotation(0, 0, 0, 0))
        animation.toValue = NSValue(caTransform3D: CATransform3DConcat(perspective, CATransform3DMakeRotation(CGFloat.pi, self.flipType == .x ? 0 : 1, self.flipType == .x ? 1 : 0, 0)))
        animation.duration = CFTimeInterval(duration)
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        animation.timingFunction = self.animationCurve.getTimingFunction()
        view.layer.add(animation, forKey: nil)
        
        CATransaction.commit()
    }
    
}
