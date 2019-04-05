//
//  UIWindow.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 23/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIWindow {

    // MARK: - Static Methods
    
    static func getVisibleViewControllerFrom(_ viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(navigationController.visibleViewController)
        } else if let tabBarController = viewController as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController)
        } else {
            if let presentedViewController = viewController?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(presentedViewController)
            } else {
                return viewController
            }
        }
    }

    // MARK: - Instance Methods

    final func updateRootViewController(with viewController: UIViewController, completion: (() -> Void)? = nil) {
        UIView.transition(with: self, duration: 0.6, options: .transitionCrossDissolve, animations: {
            self.rootViewController = viewController
        }, completion: { _ in
           completion?()
        })
    }

    // MARK: - Instance Properties

    final var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }

}
