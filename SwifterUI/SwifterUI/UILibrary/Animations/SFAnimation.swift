//
//  SFAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 19/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit

extension UIViewPropertyAnimator {
    public convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let timingParameters = UISpringTimingParameters(damping: damping, response: response, initialVelocity: initialVelocity)
        self.init(duration: 0, timingParameters: timingParameters)
    }
}

extension UISpringTimingParameters {
    
    /// - Parameters:
    ///   - damping: The 'bounciness' of the animation. Value must be between 0 and 1.
    ///   - response: The 'speed' of the animation.
    ///   - initialVelocity: The vector describing the starting motion of the property. Optional, default is `.zero`.
    public convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }
    
}

public enum SFAnimationError: Error {
    case noView
}

open class SFAnimation: NSObject {
    
    public enum SFAnimationDirection {
        case top
        case right
        case bottom
        case left
        case none
    }
    
    public enum SFAnimationType {
        case inside
        case outside
    }
    
    // MARK: - Instance Properties
    
    public final weak var view: UIView?
    open var direction: SFAnimationDirection { didSet { self.load() } }
    open var type: SFAnimationType { didSet { self.load() } }
    open var damping: CGFloat = 1 { didSet { self.load() } }
    open var initialVelocity: CGVector = .zero { didSet { self.load() } }
    open var response: CGFloat = 1 { didSet { self.load() } }
    open var animator = UIViewPropertyAnimator()
    
    // MARK: - Initializers
    
    public init(with view: UIView, direction: SFAnimationDirection = .none, type: SFAnimationType = .inside, damping: CGFloat = 1.0, response: CGFloat = 1.0, initialVelocity: CGVector = .zero) {
        self.damping = damping
        self.response = response
        self.initialVelocity = initialVelocity
        self.type = type
        self.view = view
        self.direction = direction
        super.init()
        load()
    }
    
    // MARK: - Instance Methods
    
    // load: Method immediately called after init, this prepare properties for all animations
    open func load() {
    }
    
    // start: All animations should be implemented here
    @discardableResult
    open func start() -> Guarantee<Void> {
        return Guarantee { seal in
            animator.addCompletion({ (state) in
                if state == .end {
                    seal(())
                }
            })
            animator.startAnimation()
        }
    }
    
    @discardableResult
    open func reverse() -> Guarantee<Void> {
        return Guarantee { seal in
            seal(())
        }
    }
}
















