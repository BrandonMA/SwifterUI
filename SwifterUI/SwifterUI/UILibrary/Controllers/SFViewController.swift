//
//  SFViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 25/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import MobileCoreServices

open class SFViewController: UIViewController, SFControllerColorStyle {
    
    // MARK: - Instance Properties

    public final var sfview: SFView! { return view as? SFView }
    
    open var currentColorStyle: SFColorStyle?

    open var automaticallyTintNavigationBar = false
    
    open var automaticallyAdjustsColorStyle = false {
        didSet {
            checkColorStyleListener()
        }
    }
    
    open override var prefersStatusBarHidden: Bool {
        return self.statusBarIsHidden
    }

    open var statusBarIsHidden: Bool = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }

    open var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    open override var shouldAutorotate: Bool {
        return self.autorotate
    }

    open var autorotate = true
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true) {
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        viewWillPrepareSubViews()
        viewWillSetConstraints()
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    open func viewWillPrepareSubViews() {
    }
    
    open func viewWillSetConstraints() {
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        
        if let navigationController = self.navigationController {
            prepare(navigationController: navigationController)
        }
        
        if let tabBarController = self.tabBarController {
            prepare(tabBarController: tabBarController)
        }
    }
    
    /**
     Called after viewWillAppear() is completed
     - Parameters:
     - navigationController: Current UINavigationController if it is not nil.
     */
    open func prepare(navigationController: UINavigationController) {
    }
    
    /**
     Called after viewWillAppear() is completed
     - Parameters:
     - tabBarController: Current UITabBarController if it is not nil.
     */
    open func prepare(tabBarController: UITabBarController) {
    }
    public final func checkColorStyleListener() {
        if automaticallyAdjustsColorStyle == true {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(handleBrightnessChange),
                                                   name: UIScreen.brightnessDidChangeNotification,
                                                   object: nil)
        }
    }
    
    @objc private final func handleBrightnessChange() {
        if currentColorStyle != colorStyle || currentColorStyle == nil {
            updateColors()
        }
    }

    open override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent.isKind(of: SFBulletinViewController.self) {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            viewControllerToPresent.modalTransitionStyle = .crossDissolve
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        } else if viewControllerToPresent.isKind(of: SFSlideViewController.self) {
            let manager = SFPresentationManager(animation: .pop)
            viewControllerToPresent.transitioningDelegate = manager
            viewControllerToPresent.modalPresentationStyle = .custom
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        } else {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
    
    open func updateColors() {
        DispatchQueue.main.async {

            self.updateSubviewsColors()
            
            if self.automaticallyTintNavigationBar == true {
                self.updateNavItem()
                self.statusBarStyle = self.colorStyle.statusBarStyle
            }
            
            self.setNeedsStatusBarAppearanceUpdate()
            
            self.currentColorStyle = self.colorStyle
        }
    }
}

public extension UIImagePickerControllerDelegate where Self: SFViewController & UINavigationControllerDelegate {

    func showMediaPicker(sourceType: UIImagePickerController.SourceType, mediaTypes: [String] = [kUTTypeImage as String, kUTTypeMovie as String]) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.mediaTypes = mediaTypes
        self.present(imagePicker, animated: true, completion: nil)
    }

}
