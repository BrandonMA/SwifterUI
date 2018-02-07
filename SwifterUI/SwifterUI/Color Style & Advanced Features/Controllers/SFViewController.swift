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
    
    // preferredStatusBarStyle: Override the preferred status bar style with an colorStyle's getStatusBarStyle method that automatically return the correct statusbarstyle
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }
    
    // prefersStatusBarHidden: Override the preferred status bar hidden with a dynamic way of set it
    open override var prefersStatusBarHidden: Bool {
        return self.statusBarIsHidden
    }
    
    // shouldAutorotate: Override shouldAutorotate with a dynamic way to set it
    open override var shouldAutorotate: Bool {
        return self.autorotate
    }
    
    // statusBarStyle: Dynamic way to change preferredStatusBarStyle, use this instead of override preferredStatusBarStyle
    open var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // statusBarIsHidden: Dynamic way to change prefersStatusBarHidden, use this instead of override prefersStatusBarHidden
    open var statusBarIsHidden: Bool = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // autorotate: Dynamic way to set shouldAutorotate
    open var autorotate: Bool = true
    
    open var shouldHaveAlternativeColors: Bool = false
    
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
            UIView.animate(withDuration: 0.3, animations: {
                
                self.updateSubviewsColors()
                
                if self.automaticallyTintNavigationBar == true {
                    self.navigationController?.navigationBar.barStyle = self.colorStyle.getNavigationBarStyle()
                    self.navigationController?.navigationBar.tintColor = self.colorStyle.getInteractiveColor()
                    self.navigationItem.searchController?.searchBar.barStyle = self.colorStyle.getSearchBarStyle()
                    self.navigationItem.searchController?.searchBar.tintColor = self.colorStyle.getInteractiveColor()
                    self.navigationItem.searchController?.searchBar.keyboardAppearance = self.colorStyle.getKeyboardStyle()
                    self.statusBarStyle = self.colorStyle.getStatusBarStyle()
                }
                
                self.setNeedsStatusBarAppearanceUpdate()
                
                self.currentColorStyle = self.colorStyle
                
            })
        }
    }
}
