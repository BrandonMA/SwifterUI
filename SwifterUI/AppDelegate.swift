//
//  AppDelegate.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = SFSignViewController()
        
//        let url = URL(string: "https://infinitediaries.net/wp-content/uploads/2015/12/Swift_logo-hero-1000x400@2x.jpg")!
//        URLSession.shared.dataTask(.promise, with: url).compactMap{ UIImage(data: $0.data) }.done({ image in
//            DispatchQueue.addAsyncTask(to: .main, handler: {
//                self.window?.rootViewController = SFNavigationController(rootViewController: SFImageZoomViewController(with: image))
//            })
//        })
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

