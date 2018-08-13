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
        guard let view = view else { return }
        let initialScale = CGAffineTransform(scaleX: self.type == .inside ? 0.0 : 1.0, y: self.type == .inside ? 0.0 : 1.0)
        let finalScale = CGAffineTransform(scaleX: self.type == .inside ? 1.0 : 0.000001, y: self.type == .inside ? 1.0 : 0.000001)
        view.transform = initialScale
        if self.type == .inside {
            view.alpha = 1.0
        }
        animator = UIViewPropertyAnimator(damping: self.damping, response: self.response, initialVelocity: self.initialVelocity)
        animator.addAnimations {
            view.transform = finalScale
            if self.type == .outside {
                view.alpha = 0.0
            }
        }
    }
    
    // MARK: - Instance Methods
    
    @discardableResult
    open override func reverse() -> Guarantee<Void> {
        type = type == .inside ? .outside : .inside
        load()
        return start()
    }
}
