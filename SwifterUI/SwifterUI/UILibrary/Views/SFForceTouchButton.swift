//
//  SFForceTouchButton.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/19/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFForceTouchButton: SFFluidButton {
    
    public enum ForceState {
        
        /// The button is ready to be activiated. Default state.
        case reset
        
        /// The button has been pressed with enough force.
        case activated
        
        /// The button has recently switched on/off.
        case confirmed
        
    }
    
    /// Whether the button is on or off.
    open var isOn = false
    
    /// The current state of the force press.
    open var forceState: ForceState = .reset
    
    /// Whether the touch has exited the bounds of the button.
    /// This is used to cancel touches that move outisde of its bounds.
    open var touchExited = false
    
    open var activationFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    open var confirmationFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    open var minWidth: CGFloat { return bounds.size.width }
    open var maxWidth: CGFloat { return bounds.size.width * 1.75 }
    
    open var activationForce: CGFloat = 0.5
    open var confirmationForce: CGFloat = 0.49
    open var resetForce: CGFloat = 0.4
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchExited = false
        touchMoved(touch: touches.first)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touchMoved(touch: touches.first)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEnded(touch: touches.first)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchEnded(touch: touches.first)
    }
    
    open func touchMoved(touch: UITouch?) {
        guard let touch = touch else { return }
        guard !touchExited else { return }
        
        let cancelDistance: CGFloat = minWidth / 2 + 20
        touch.location(in: self)
        guard touch.location(in: self).distance(to: CGPoint(x: bounds.midX, y: bounds.midY)) < cancelDistance else {
            // the touch has moved outside of the bounds of the button
            touchExited = true
            forceState = .reset
            animateToRest()
            return
        }
        
        let force = touch.force / touch.maximumPossibleForce
        let scale = 1 + (maxWidth / minWidth - 1) * force
        
        // update the button's size and color
        transform = CGAffineTransform(scaleX: scale, y: scale)
        
        //        if !isOn { backgroundColor = UIColor(white: 0.2 - force * 0.2, alpha: 1) }
        
        switch forceState {
        case .reset:
            if force >= activationForce {
                forceState = .activated
                activationFeedbackGenerator.impactOccurred()
            }
        case .activated:
            if force <= confirmationForce {
                forceState = .confirmed
                activate()
            }
        case .confirmed:
            if force <= resetForce {
                forceState = .reset
            }
        }
        
    }
    
    open func touchEnded(touch: UITouch?) {
        guard !touchExited else { return }
        if forceState == .activated {
            activate()
        }
        forceState = .reset
        performActions()
        animateToRest()
    }
    
    open override func addTargets() {}
    
    open func activate() {
        
        isOn = !isOn
        
        if useHighlightTextColor || isOn {
            titleLabel.textColor = highlightedTextColor ?? colorStyle.getInteractiveColor()
        } else {
            titleLabel.textColor = useAlternativeColors ? colorStyle.getInteractiveColor() : colorStyle.getTextColor()
        }
        
        backgroundColor = isOn ? highlightedColor ?? (useAlternativeColors ? .white : colorStyle.getContrastColor()) : normalColor
        confirmationFeedbackGenerator.impactOccurred()
    }
    
    open func animateToRest() {
        let timingParameters = UISpringTimingParameters(damping: 0.4, response: 0.2)
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
        animator.addAnimations {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.backgroundColor = self.isOn ? self.highlightedColor ?? (self.useAlternativeColors ? .white : self.colorStyle.getContrastColor()) : self.normalColor
        }
        animator.isInterruptible = true
        animator.startAnimation()
    }
    
    open override func updateColors() {
        
        if useHighlightTextColor || isOn {
            titleLabel.textColor = highlightedTextColor ?? colorStyle.getInteractiveColor()
        } else if let textColor = textColor {
            titleLabel.textColor = textColor
        } else {
            titleLabel.textColor = useAlternativeColors ? colorStyle.getInteractiveColor() : colorStyle.getTextColor()
        }
        
        if isOn {
            normalColor = useAlternativeColors ? .clear : colorStyle.getAlternativeColor()
            backgroundColor = highlightedColor ?? (useAlternativeColors ? .white : colorStyle.getContrastColor())
        } else {
            backgroundColor = useAlternativeColors ? .clear : colorStyle.getAlternativeColor()
            normalColor = backgroundColor
        }
        
        
    }
    
}
