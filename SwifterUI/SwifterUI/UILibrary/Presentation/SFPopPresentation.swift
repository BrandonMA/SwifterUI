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
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.backgroundColor = .black
        return view
    }()
    
    // MARK: - Initializers
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: UIScreen.brightnessDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Instance Methods
    
    @objc private func updateColors() {
        guard let window = UIApplication.shared.keyWindow else { fatalError() }
        UIView.animate(withDuration: 0.6, animations: { window.backgroundColor = .black })
    }
    
    override open func presentationTransitionWillBegin() {
        
        if let presentingViewController = presentingViewController as? UINavigationController {
            if let view = presentingViewController.viewIfLoaded {
                view.addSubview(shadowView)
            }
        } else {
            presentingViewController.view.addSubview(shadowView)
        }
        
        presentingViewController.view.layer.masksToBounds = true
        
        shadowView.clipSides(useSafeArea: false)
        updateColors()
        startPresentationAnimation()
    }
    
    private func startPresentationAnimation() {
        
        guard var mainController = self.presentingViewController as? SFControllerColorStyle else { return }
        shadowView.frame = presentingViewController.view.frame
        
        let animator = UIViewPropertyAnimator(damping: 0.7, response: 0.6)
        
        animator.addAnimations {
            
            self.shadowView.alpha = 0.5
            
            if (self.presentedView?.useCompactInterface)! {
                self.presentingViewController.view.frame.size.height -= UIApplication.shared.statusBarFrame.height * 2
                self.presentingViewController.view.frame.origin.y += UIApplication.shared.statusBarFrame.height
                self.presentingViewController.view.layer.cornerRadius = 20
            }
            
            self.presentedView?.layer.cornerRadius = 20
            self.presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            if let tabBar = mainController as? SFTabBarController {
                if var child = tabBar.selectedViewController as? SFControllerColorStyle {
                    child.automaticallyTintNavigationBar = false
                    child.statusBarStyle = .lightContent
                }
            }
            
            mainController.automaticallyTintNavigationBar = false
            mainController.statusBarStyle = .lightContent
            
        }
        
        animator.startAnimation()
    }
    
    open override func dismissalTransitionWillBegin() {
        if let presentingViewController = self.presentingViewController as? UINavigationController {
            guard let topViewController = presentingViewController.topViewController as? SFViewController else { return }
            topViewController.updateColors()
        }
        updateColors()
        startDismissalAnimation()
    }
    
    private func startDismissalAnimation() {
        
        guard var mainController = self.presentingViewController as? SFControllerColorStyle else { return }
        
        let animator = UIViewPropertyAnimator(damping: 0.7, response: 0.6)
        
        animator.addAnimations {
            self.shadowView.alpha = 0
            
            if let tabBar = mainController as? SFTabBarController {
                if var child = tabBar.selectedViewController as? SFControllerColorStyle {
                    child.automaticallyTintNavigationBar = true
                    child.updateColors()
                }
            }
            
            mainController.automaticallyTintNavigationBar = true
            mainController.updateColors()
            
            if (self.presentedView?.useCompactInterface)! {
                self.presentingViewController.view.frame.size.height += UIApplication.shared.statusBarFrame.height * 2
                self.presentingViewController.view.frame.origin.y -= UIApplication.shared.statusBarFrame.height
                self.presentingViewController.view.layer.cornerRadius = 0
            }
        }
        
        animator.addCompletion { (_) in
            self.shadowView.removeFromSuperview()
        }
        
        animator.startAnimation()
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
