//
//  LoginManager.swift
//
//  Created by brandon maldonado alonso on 24/02/18.
//  Copyright © 2018 brandon maldonado alonso. All rights reserved.
//

import UIKit
import FirebaseAuth

public protocol FirebaseLogin {
    
    // MARK: - Instance Methods
    
    func handleFirebaseLogin(user: User?, error: Error?, completion: ((User) -> Void)?)
}

public extension FirebaseLogin {
    
    // MARK: - Instance Methods
    
    public func handleFirebaseLogin(user: User?, error: Error?, completion: ((User) -> Void)?) {
        if let error = error {
            UIApplication.shared.keyWindow?.visibleViewController?.showError(message: error.localizedDescription)
        }
        if let user = user {
            completion?(user)
        } else {
            UIApplication.shared.keyWindow?.visibleViewController?.showError()
        }
    }
}













