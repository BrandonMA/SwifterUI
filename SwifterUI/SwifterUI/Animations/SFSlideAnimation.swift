//
//  SFSlideAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSlideAnimation: SFAnimation {
    
    // MARK: - Instance Methods
    
    open override func load() {
        guard let view = self.view else { return }
        let maxWidth = view.superview?.bounds.width ?? UIScreen.main.bounds.width
        let maxHeight = view.superview?.bounds.height ?? UIScreen.main.bounds.height
        
        initialFrame = view.frame
        finalFrame = view.frame
        
        if direction == .right && type == .inside {
            initialFrame.origin.x = maxWidth + initialFrame.size.width
        } else if direction == .left && type == .inside {
            initialFrame.origin.x = 0 - initialFrame.size.width
        } else if direction == .top && type == .inside {
            initialFrame.origin.y = 0 - initialFrame.size.height
        } else if direction == .bottom && type == .inside {
            initialFrame.origin.y = maxHeight + initialFrame.size.height
        } else if direction == .right && type == .outside {
            finalFrame.origin.x = maxWidth + finalFrame.size.width
        } else if direction == .left && type == .outside {
            finalFrame.origin.x = 0 - finalFrame.size.width
        } else if direction == .top && type == .outside {
            finalFrame.origin.y = 0 - finalFrame.size.height
        } else if direction == .bottom && type == .outside {
            finalFrame.origin.y = maxHeight + finalFrame.size.height
        }
        
        view.frame = initialFrame
        
    }
    
    open override func start() {
        guard let view = self.view else { return }
        view.frame = initialFrame
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: [animationCurve.getAnimationOptions(), .allowUserInteraction], animations: {
            view.frame = self.finalFrame
        }, completion: { finished in
            self.delegate?.didFinishAnimation()
        })
    }
}
