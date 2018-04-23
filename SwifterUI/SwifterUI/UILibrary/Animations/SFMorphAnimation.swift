//
//  SFMorphAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit

open class SFMorphAnimation: SFAnimation {
    
    // MARK: - Instance Methods
    
    open override func load() {
        super.load()
        animationCurve = .easeOut
    }
    
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
            
            let morphX = CAKeyframeAnimation()
            morphX.keyPath = "transform.scale.x"
            morphX.values = [1, 1.3*force, 0.7, 1.3*force, 1]
            morphX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphX.timingFunction = animationCurve.getTimingFunction()
            morphX.duration = CFTimeInterval(duration)
            morphX.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            view.layer.add(morphX, forKey: "morphX")
            
            let morphY = CAKeyframeAnimation()
            morphY.keyPath = "transform.scale.y"
            morphY.values = [1, 0.7, 1.3*force, 0.7, 1]
            morphY.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphY.timingFunction = animationCurve.getTimingFunction()
            morphY.duration = CFTimeInterval(duration)
            morphY.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            view.layer.add(morphY, forKey: "morphY")
            
            CATransaction.commit()
        }
    }
}
