//
//  SFAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 19/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFAnimationDelegate: class {
    func finished(animation: SFAnimation)
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
        case none
    }
    
    // MARK: - Instance Properties
    
    open weak var view: UIView?
    open weak var delegate: SFAnimationDelegate? = nil
    open var direction: SFAnimationDirection { didSet { self.load() } }
    open var type: SFAnimationType { didSet { self.load() } }
    open var delay: TimeInterval = 0
    open var duration: TimeInterval = 1
    open var damping: CGFloat = 1
    open var velocity: CGFloat = 0
    open var force: CGFloat = 1
    open var center: CGPoint = CGPoint.zero
    open var initialFrame: CGRect = CGRect.zero
    open var finalFrame: CGRect = CGRect.zero
    open var initialScaleX: CGFloat = 1
    open var initialScaleY: CGFloat = 1
    open var finalScaleX: CGFloat = 1
    open var finalScaleY: CGFloat = 1
    open var initialAlpha: CGFloat = 1.0 { didSet { self.view?.alpha = self.initialAlpha } }
    open var finalAlpha: CGFloat = 1.0
    open var animationCurve: SFAnimationCurve = .easeOut
    
    // MARK: - Initializers
    
    public init(with view: UIView, direction: SFAnimationDirection = .none, type: SFAnimationType = .none) {
        self.type = type
        self.view = view
        self.direction = direction
        super.init()
        load()
    }
    
    // MARK: - Instance Methods
    
    // load: Methods inmediatly called after init, this prepare properties for all animations
    open func load() {
    }
    
    // start: All animations should be implemented here
    open func start() {
        
    }
    
    open func inverted() {
        self.type = self.type == .inside ? .outside : .inside
    }
}
















