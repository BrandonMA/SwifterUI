//
//  SFViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 25/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFViewController: UIViewController, SFControllerColorStyle {
    
    // MARK: - Instance Properties
    
    open var currentColorStyle: SFColorStyle? = nil
    
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
    
    var sfview: SFView {
        return view as! SFView
    }
        
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
            UIView.animate(withDuration: 0.6, animations: {
                
                self.updateSubviewsColors()
                
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
