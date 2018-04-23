//
//  SFAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 19/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit

public enum SFAnimationError: Error {
    case noParent
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
    
    public final weak var view: UIView?
    public final var direction: SFAnimationDirection { didSet { self.load() } }
    public final var type: SFAnimationType { didSet { self.load() } }
    public final var delay: TimeInterval = 0
    public final var duration: TimeInterval = 1
    public final var damping: CGFloat = 1
    public final var velocity: CGFloat = 0
    public final var force: CGFloat = 1
    public final var center: CGPoint = CGPoint.zero
    public final var initialFrame: CGRect = CGRect.zero
    public final var finalFrame: CGRect = CGRect.zero
    public final var initialScaleX: CGFloat = 1
    public final var initialScaleY: CGFloat = 1
    public final var finalScaleX: CGFloat = 1
    public final var finalScaleY: CGFloat = 1
    public final var initialAlpha: CGFloat = 1.0 { didSet { self.view?.alpha = self.initialAlpha } }
    public final var finalAlpha: CGFloat = 1.0
    public final var animationCurve: SFAnimationCurve = .easeOut
    
    // MARK: - Initializers
    
    public init(with view: UIView, direction: SFAnimationDirection = .none, type: SFAnimationType = .none) {
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
    open func start() -> Promise<Void> {
        return Promise { seal in
            seal.fulfill(())
        }
    }
    
    public final func inverted() {
        self.type = self.type == .inside ? .outside : .inside
    }
}
















