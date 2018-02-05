//
//  SFPopPresentation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 27/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPopPresentation: UIPresentationController {
    
    // MARK: - Instance Properties
    
    lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .UIScreenBrightnessDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Instance Methods
    
    @objc private func updateColors() {
        if let presentingController = self.presentingViewController as? SFControllerColorStyle {
            guard let window = UIApplication.shared.keyWindow else { fatalError() }
            UIView.animate(withDuration: 0.6, animations: {
                self.blurView.effect = presentingController.colorStyle.getEffectStyle()
                window.backgroundColor = presentingController.colorStyle == .dark ? UIColor(hex: "262626") : UIColor(hex: "000000")
            })
        }
    }
    
    override open func presentationTransitionWillBegin() {
        
        presentingViewController.view.addSubview(blurView)
        presentingViewController.view.layer.masksToBounds = true
        blurView.clipEdges()
        updateColors()
        
        UIView.animate(withDuration: 0.6) {
            
            if var presentingController = self.presentingViewController as? SFControllerColorStyle {
                self.blurView.effect = presentingController.colorStyle.getEffectStyle()
                presentingController.automaticallyTintNavigationBar = false
                presentingController.statusBarStyle = .lightContent
            }
            
            if (self.presentedView?.useCompactInterface)! {
                self.presentedView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 1)
                self.presentingViewController.view.frame.size.height -= UIApplication.shared.statusBarFrame.height * 2
                self.presentingViewController.view.frame.origin.y += UIApplication.shared.statusBarFrame.height
                self.presentingViewController.view.layer.cornerRadius = 20
            }
            
            self.presentedView?.layer.cornerRadius = 20
        }
    }
    
    open override func dismissalTransitionWillBegin() {
        
        updateColors()
        
        UIView.animate(withDuration: 0.6, animations: {
            
            if var presentingController = self.presentingViewController as? SFControllerColorStyle {
                self.blurView.effect = nil
                presentingController.automaticallyTintNavigationBar = true
                presentingController.updateColors()
            }
            self.presentedView?.layer.cornerRadius = 0
            
            if (self.presentedView?.useCompactInterface)! {
                self.presentingViewController.view.transform = CGAffineTransform.identity
                self.presentingViewController.view.frame.size.height += UIApplication.shared.statusBarFrame.height * 2
                self.presentingViewController.view.frame.origin.y -= UIApplication.shared.statusBarFrame.height
                self.presentingViewController.view.layer.cornerRadius = 0
            }
            
        }, completion: { finished in
            self.blurView.removeFromSuperview()
        })
        
    }
    
    override open func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override open func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let width = (self.presentedView?.useCompactInterface)! ? parentSize.width : parentSize.width * 0.7
        let height = (self.presentedView?.useCompactInterface)! ? parentSize.height - (UIApplication.shared.statusBarFrame.height + 10) : parentSize.height * 0.9
        return CGSize(width: width, height: height)
    }
    
    override open var frameOfPresentedViewInContainerView: CGRect {
        var frame = CGRect.zero
        guard let containerView = containerView else { return CGRect.zero }
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
        
        if (self.presentedView?.useCompactInterface)! {
            frame.origin = CGPoint(x: 0, y: UIApplication.shared.statusBarFrame.height + 10)
        } else {
            frame.origin = CGPoint(x: (containerView.bounds.size.width / 2) - (frame.size.width / 2), y: (containerView.bounds.size.height / 2) - (frame.size.height / 2))
        }
        
        return frame
    }
}

public extension UIView {
    public var useCompactInterface: Bool {
        return self.traitCollection.horizontalSizeClass == .compact || self.traitCollection.verticalSizeClass == .compact
    }
}


























