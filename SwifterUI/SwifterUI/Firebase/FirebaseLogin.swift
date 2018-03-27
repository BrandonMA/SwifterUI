////
////  LoginManager.swift
////
////  Created by brandon maldonado alonso on 24/02/18.
////  Copyright © 2018 brandon maldonado alonso. All rights reserved.
////
//
//import UIKit
//import FirebaseAuth
//import PromiseKit
//
//public protocol FirebaseLogin {
//
//    // MARK: - Instance Methods
//
//    func handleFirebaseLogin(user: User?, error: Error?) -> Promise<User>
//}
//
//public extension FirebaseLogin {
//
//    // MARK: - Instance Methods
//
//    public func handleFirebaseLogin(user: User?, error: Error?) -> Promise<User> {
//
//        return Promise { seal in
//
//            DispatchQueue.addAsyncTask(to: .background, handler: {
//                seal.resolve(user, error)
//            })
//
//        }
//
//    }
//}

