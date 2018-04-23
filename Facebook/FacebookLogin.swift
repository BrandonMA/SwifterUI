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
import PromiseKit

enum FacebookError: Error {
    case cancel
}

public protocol FacebookLogin {

    // MARK: - Instance Methods

    func logIn(withReadPermissions permissions: [String],
               from viewController: UIViewController,
               handler: @escaping (FBSDKLoginManagerLoginResult) -> Void)

    func getProfile() -> Promise<FBSDKProfile>
}

public extension FacebookLogin {

    // MARK: - Instance Methods

    public func logIn(withReadPermissions permissions: [String],
                      from viewController: UIViewController) -> Promise<FBSDKLoginManagerLoginResult> {

        let manager = FBSDKLoginManager()

        return Promise { seal in

            DispatchQueue.addAsyncTask(to: .background, handler: {

                manager.logIn(withReadPermissions: permissions, from: viewController, handler: { (result, error) in
                    if let result = result {
                        seal.fulfill(result)
                    } else {
                        UIApplication.shared.keyWindow?.visibleViewController?.showError(message: error?.localizedDescription)
                        seal.resolve(result, error)
                    }
                })

            })

        }

    }

    public func getProfile() -> Promise<FBSDKProfile> {

        return Promise { seal in

            DispatchQueue.addAsyncTask(to: .background, handler: {

                FBSDKProfile.loadCurrentProfile(completion: { (profile, error) in
                    if let profile = profile {
                        seal.fulfill(profile)
                    } else {
                        UIApplication.shared.keyWindow?.visibleViewController?.showError(message: error?.localizedDescription)
                        seal.resolve(profile, error)
                    }

                })

            })

        }

    }
}
