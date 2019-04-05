//
//  SFTabViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 20/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTabBarController: UITabBarController, SFControllerColorStyle {
    
    // MARK: - Instance Properties
    
    open var currentColorStyle: SFColorStyle?
    
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
    
    public override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
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
    
    open func checkColorStyleListener() {
        if self.automaticallyAdjustsColorStyle == true {
            NotificationCenter.default.addObserver(self, selector: #selector(handleBrightnessChange), name: UIScreen.brightnessDidChangeNotification, object: nil)
        }
    }
    
    @objc final func handleBrightnessChange() {
        if currentColorStyle != self.colorStyle || self.currentColorStyle == nil {
            updateColors()
        }
    }
    
    open func updateColors() {
        DispatchQueue.main.async {
            self.tabBar.tintColor = self.colorStyle.interactiveColor
            self.tabBar.barStyle = self.colorStyle.barStyle
            
            if self.automaticallyTintNavigationBar == true {
                self.updateNavItem()
                self.statusBarStyle = self.colorStyle.statusBarStyle
            }
        }
    }
    
}
