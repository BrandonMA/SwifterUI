//
//  LoginManager.swift
//
//  Created by brandon maldonado alonso on 24/02/18.
//  Copyright © 2018 brandon maldonado alonso. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

public protocol LoginManager {
    func showLoginError(title: String?, message: String?)
}

public extension LoginManager where Self: UIViewController {
    public func showLoginError(title: String? = nil, message: String? = nil) {
        let errorTitle = title ?? "Error de autenticación"
        let errorMessage = message ?? "Ocurrio un problema con la autenticación, intente de nuevo por favor"
        let ok = "Entendido"
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

public protocol FirebaseLogin: LoginManager {
    func handleFirebaseLogin(user: User?, error: Error?, completion: ((User) -> Void)?)
}

public extension FirebaseLogin where Self: UIViewController {
    
    public func handleFirebaseLogin(user: User?, error: Error?, completion: ((User) -> Void)?) {
        if error != nil {
            showLoginError()
        }
        if let user = user {
            completion?(user)
        } else {
            showLoginError()
        }
    }
}

public protocol FacebookLogin: LoginManager {
    func logIn(withReadPermissions permissions: [String], from viewController: UIViewController, handler: @escaping (FBSDKLoginManagerLoginResult) -> Void)
}

public extension FacebookLogin where Self: UIViewController {
    public func logIn(withReadPermissions permissions: [String], from viewController: UIViewController, handler: @escaping (FBSDKLoginManagerLoginResult) -> Void) {
        let manager = FBSDKLoginManager()
        manager.logIn(withReadPermissions: permissions, from: viewController) { (result, error) in
            if error != nil {
                self.showLoginError()
            } else if let result = result {
                if result.isCancelled {
                    self.showLoginError()
                } else {
                    handler(result)
                }
            }
        }
    }
}
