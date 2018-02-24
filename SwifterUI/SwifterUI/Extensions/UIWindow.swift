//
//  UIWindow.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 23/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIWindow {
    public static func updateRootViewController(with viewController: UIViewController, completion: ((Bool) -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        UIView.transition(with: window, duration: 0.6, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
        }, completion: completion)
    }
}
