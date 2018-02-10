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
    
    open var currentColorStyle: SFColorStyle? = nil
    
    open var automaticallyAdjustsColorStyle: Bool = true
    
    open var automaticallyTintNavigationBar: Bool = true
    
    open var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }
    
    // MARK: - Initializers
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
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
    
    // MARK: - Instance Methods
    
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
        
        if self.automaticallyTintNavigationBar == true {
            navigationBar.barStyle = colorStyle.getNavigationBarStyle()
            navigationBar.tintColor = self.colorStyle.getInteractiveColor()
            updateNavItem()
            statusBarStyle = self.colorStyle.getStatusBarStyle()
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.currentColorStyle = self.colorStyle
    }
}
