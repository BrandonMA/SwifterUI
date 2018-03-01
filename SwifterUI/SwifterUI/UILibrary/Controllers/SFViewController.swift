//
//  SFViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 25/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

private extension UIViewController {
    
    private func showLoadingView() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.restorationIdentifier = "loadingView"
        view.backgroundColor = .red
        view.alpha = 0
        self.view.addSubview(view)
        view.clipEdges(useSafeArea: false)
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            view.alpha = 1
        }
    }
    
    private func removeLoadingView() {
        for view in view.subviews {
            if view.restorationIdentifier == "loadingView" {
                UIView.animate(withDuration: 0.5, animations: {
                    view.alpha = 0
                }, completion: { (finished) in
                    view.removeFromSuperview()
                })
            }
        }
    }
    
}

open class SFViewController: UIViewController, SFControllerColorStyle {
    
    // MARK: - Instance Properties
    
    public final var currentColorStyle: SFColorStyle? = nil
    
    open var automaticallyAdjustsColorStyle: Bool = false {
        didSet {
            checkColorStyleListener()
        }
    }
    
    open var automaticallyTintNavigationBar: Bool = false
    
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
    
    public required init(automaticallyAdjustsColorStyle: Bool = true) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        self.automaticallyTintNavigationBar = automaticallyAdjustsColorStyle
        super.init(nibName: nil, bundle: nil)
        checkColorStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Instance Methods
    
    open override func loadView() {
        self.view = SFView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
    }
    
    public final func checkColorStyleListener() {
        if self.automaticallyAdjustsColorStyle == true {
            NotificationCenter.default.addObserver(self, selector: #selector(handleBrightnessChange), name: .UIScreenBrightnessDidChange, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc private final func handleBrightnessChange() {
        if currentColorStyle != self.colorStyle || self.currentColorStyle == nil {
            updateColors()
        }
    }
    
    open func updateColors() {
        DispatchQueue.addAsyncTask(to: .main) {
            UIView.animate(withDuration: 0.6, animations: {
                
                self.updateSubviewsColors()
                UIApplication.shared.keyWindow?.backgroundColor = self.view.backgroundColor
                if self.automaticallyTintNavigationBar == true {
                    self.updateNavItem()
                    self.statusBarStyle = self.colorStyle.getStatusBarStyle()
                }
                
                self.setNeedsStatusBarAppearanceUpdate()
                
                self.currentColorStyle = self.colorStyle
                
            })
        }
    }
}

