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
    }
    
    open func checkColorStyleListener() {
        if self.automaticallyAdjustsColorStyle == true {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(handleBrightnessChange),
                                                   name: UIScreen.brightnessDidChangeNotification,
                                                   object: nil)
        }
    }
    
    @objc final func handleBrightnessChange() {
        if currentColorStyle != self.colorStyle || self.currentColorStyle == nil {
            updateColors()
        }
    }
    
    open func updateColors() {
        
        DispatchQueue.main.async {
            
            self.navigationBar.barStyle = self.colorStyle.barStyle
            self.navigationBar.tintColor = self.colorStyle.interactiveColor
            self.updateNavItem()
            
            if self.automaticallyTintNavigationBar == true {
                self.statusBarStyle = self.colorStyle.statusBarStyle
            }
            
            self.setNeedsStatusBarAppearanceUpdate()
            self.currentColorStyle = self.colorStyle
        }
    }
}
