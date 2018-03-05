//
//  SFTabViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 20/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTabBarController: UITabBarController, SFControllerColorStyle {
    
    public enum SFTabBarAnimation {
        case none
        case shake
        case morph
        case squeeze
        case wobble
        case flip
        case rotate
    }
    
    // MARK: - Instance Properties
    
    open var animation: SFTabBarAnimation = .none
    
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
    
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let view = item.value(forKey: "view") as? UIView {
            let imageView = view.subviews[0]
            switch animation {
            case .none: return
            case .shake: SFShakeAnimation(with: imageView).start()
            case .morph: SFMorphAnimation(with: imageView).start()
            case .squeeze: SFSqueezeAnimation(with: imageView).start()
            case .wobble: SFWobbleAnimation(with: imageView).start()
            case .flip: SFFlipAnimation(with: imageView).start()
            case .rotate: SFRotationAnimation(with: imageView).start()
            }
        }
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
        UIView.animate(withDuration: 0.6) {
            self.tabBar.tintColor = self.colorStyle.getInteractiveColor()
            self.tabBar.barStyle = self.colorStyle.getBarStyle()
            
            if self.automaticallyTintNavigationBar == true {
                self.updateNavItem()
                self.statusBarStyle = self.colorStyle.getStatusBarStyle()
            }
        }
    }
    
}
