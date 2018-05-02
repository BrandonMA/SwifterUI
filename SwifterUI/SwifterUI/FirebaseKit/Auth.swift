//
//  Auth.swift
//  WhatsDoc
//
//  Created by brandon maldonado alonso on 13/04/18.
//  Copyright © 2018 brandon maldonado alonso. All rights reserved.
//

import PromiseKit
import Firebase

public extension Auth {
    
    public func createUser(with email: String, password: String) -> Promise<User> {
        return Promise { seal in
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let user = user {
                    seal.fulfill(user)
                } else if let error = error {
                    seal.reject(error)
                }
            }
        }
    }
    
    public func signIn(with email: String, password: String) -> Promise<User> {
        return Promise { seal in
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let user = user {
                    seal.fulfill(user)
                } else if let error = error {
                    seal.reject(error)
                }
            })
        }
    }
    
    public func signIn(credential: AuthCredential) -> Promise<User> {
        return Promise { seal in
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let user = user {
                    seal.fulfill(user)
                } else if let error = error {
                    seal.reject(error)
                }
            })
        }
    }
    
}
