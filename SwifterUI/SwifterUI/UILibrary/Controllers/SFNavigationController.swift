//
//  SFNavigationController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFNavigationController: UINavigationController, SFControllerColorStyle {
    
    // MARK: - Instance Properties
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var edgeSwipeGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    
    open var currentColorStyle: SFColorStyle? = nil
    
    open var automaticallyAdjustsColorStyle: Bool = true {
        didSet {
            checkColorStyleListener()
        }
    }
    
    open var automaticallyTintNavigationBar: Bool = true
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }
    
    open override var prefersStatusBarHidden: Bool {
        return self.statusBarIsHidden
    }
    
    open override var shouldAutorotate: Bool {
        return self.autorotate
    }
    
    open var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    open var statusBarIsHidden: Bool = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    open var autorotate: Bool = true
    
    // MARK: - Initializers
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        checkColorStyle()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        checkColorStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        edgeSwipeGestureRecognizer!.edges = .left
        view.addGestureRecognizer(edgeSwipeGestureRecognizer!)
    }
    
    open func checkColorStyleListener() {
        if self.automaticallyAdjustsColorStyle == true {
            NotificationCenter.default.addObserver(self, selector: #selector(handleBrightnessChange), name: .UIScreenBrightnessDidChange, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc final func handleBrightnessChange() {
        if currentColorStyle != self.colorStyle || self.currentColorStyle == nil {
            updateColors()
        }
    }
    
    open func updateColors() {
        
        DispatchQueue.addAsyncTask(to: .main) {
            
            self.navigationBar.barStyle = self.colorStyle.getBarStyle()
            self.navigationBar.tintColor = self.colorStyle.getInteractiveColor()
            self.updateNavItem()
            
            if self.automaticallyTintNavigationBar == true {
                self.statusBarStyle = self.colorStyle.getStatusBarStyle()
            }
            
            self.setNeedsStatusBarAppearanceUpdate()
            self.currentColorStyle = self.colorStyle
        }
    }
    
    @objc open func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let percent = gestureRecognizer.translation(in: gestureRecognizer.view!).x / gestureRecognizer.view!.bounds.size.width
        if gestureRecognizer.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            interactionController?.update(percent)
        } else if gestureRecognizer.state == .ended {
            if percent > 0.5 && gestureRecognizer.state != .cancelled {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
}

extension SFNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if toVC.isKind(of: SFImageZoomViewController.self) || fromVC.isKind(of: SFImageZoomViewController.self) {
            if operation == .push {
                return SFFadeAnimationController(presenting: true)
            } else {
                return SFFadeAnimationController(presenting: false)
            }
        }
        
        return nil
    }
    
}

