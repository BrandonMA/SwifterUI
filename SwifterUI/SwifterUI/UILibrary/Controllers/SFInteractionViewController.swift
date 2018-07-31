//
//  SFInteractionViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 09/04/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFInteractionViewController {
    
    // MARK: - Instance Properties
    
    var mainView: UIView { get }
    var animator: UIDynamicAnimator { get set }
    var snapping: UISnapBehavior? { get set }
    
    // MARK: - Instance Methods
    
    func returnToMainViewController(completion: (() -> Void)?)
    func moveView(recognizer: UIPanGestureRecognizer)
}

extension SFInteractionViewController where Self: UIViewController {
    
    // MARK: - Instance Methods
    
    public func returnToMainViewController(completion: (() -> Void)? = nil) {
        let animation = SFScaleAnimation(with: mainView, type: .outside)
        animation.duration = 1.0
        animation.damping = 0.7
        animation.velocity = 0.8
        animation.start()
        DispatchQueue.delay(by: 0.35, dispatchLevel: .main) {
            self.dismiss(animated: true, completion: completion)
        }
    }
    
    public func moveView(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            guard let snapping = snapping else { return }
            animator.removeBehavior(snapping)
        case .changed:
            let translation = recognizer.translation(in: view)
            mainView.center = CGPoint(x: mainView.center.x + translation.x,
                                      y: mainView.center.y + translation.y)
            recognizer.setTranslation(.zero, in: view)
        case .ended, .cancelled, .failed:
            guard let snapping = snapping else { return }
            animator.addBehavior(snapping)
        case .possible:
            break
        }
    }
}
