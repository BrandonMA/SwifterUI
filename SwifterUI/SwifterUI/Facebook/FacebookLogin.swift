//
//  FacebookLogin.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 24/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

public protocol FacebookLogin {
    
    // MARK: - Instance Methods
    
    func logIn(withReadPermissions permissions: [String], from viewController: UIViewController, handler: @escaping (FBSDKLoginManagerLoginResult) -> Void)
    func getProfile(completion: @escaping (FBSDKProfile) -> Void)
}

public extension FacebookLogin {
    
    // MARK: - Instance Methods
    
    public func logIn(withReadPermissions permissions: [String], from viewController: UIViewController, handler: @escaping (FBSDKLoginManagerLoginResult) -> Void) {
        let manager = FBSDKLoginManager()
        manager.logIn(withReadPermissions: permissions, from: viewController) { (result, error) in
            if let error = error {
                UIApplication.shared.keyWindow?.visibleViewController?.showError(message: error.localizedDescription)
            } else if let result = result {
                if result.isCancelled {
                    UIApplication.shared.keyWindow?.visibleViewController?.showError()
                } else {
                    handler(result)
                }
            }
        }
    }
    
    public func getProfile(completion: @escaping (FBSDKProfile) -> Void) {
        FBSDKProfile.loadCurrentProfile { (profile, error) in
            if let error = error {
                UIApplication.shared.keyWindow?.visibleViewController?.showError(message: error.localizedDescription)
            } else if let profile = profile {
                completion(profile)
            }
        }
    }
}
