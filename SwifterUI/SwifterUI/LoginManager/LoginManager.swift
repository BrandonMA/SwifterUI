//
//  LoginManager.swift
//
//  Created by brandon maldonado alonso on 24/02/18.
//  Copyright © 2018 brandon maldonado alonso. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

public extension UIViewController {
    public func showError(title: String? = nil, message: String? = nil) {
        let errorTitle = title ?? "Error"
        let errorMessage = message ?? "Ocurrio un problema, intente de nuevo por favor"
        let ok = "Entendido"
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

public protocol FirebaseLogin {
    func handleFirebaseLogin(user: User?, error: Error?, completion: ((User) -> Void)?)
}

public extension FirebaseLogin where Self: UIViewController {
    
    public func handleFirebaseLogin(user: User?, error: Error?, completion: ((User) -> Void)?) {
        if let error = error {
            showError(message: error.localizedDescription)
        }
        if let user = user {
            completion?(user)
        } else {
            showError()
        }
    }
}

public protocol FacebookLogin {
    func logIn(withReadPermissions permissions: [String], from viewController: UIViewController, handler: @escaping (FBSDKLoginManagerLoginResult) -> Void)
    func getProfile(completion: (FBSDKProfile) -> Void)
}

public extension FacebookLogin where Self: UIViewController {
    public func logIn(withReadPermissions permissions: [String], from viewController: UIViewController, handler: @escaping (FBSDKLoginManagerLoginResult) -> Void) {
        let manager = FBSDKLoginManager()
        manager.logIn(withReadPermissions: permissions, from: viewController) { (result, error) in
            if let error = error {
                self.showError(message: error.localizedDescription)
            } else if let result = result {
                if result.isCancelled {
                    self.showError()
                } else {
                    handler(result)
                }
            }
        }
    }
    
    public func getProfile(completion: @escaping (FBSDKProfile) -> Void) {
        FBSDKProfile.loadCurrentProfile { (profile, error) in
            if let error = error {
                self.showError(message: error.localizedDescription)
            } else if let profile = profile {
                completion(profile)
            }
        }
    }
}













