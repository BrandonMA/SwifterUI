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
        
        var controllers: [SFViewController] = []
        for i in 0...2 {
            let controller = i % 2 == 0 ? SFSignViewController() : ViewController()
            controller.title = "\(i) controller"
            controllers.append(controller)
        }
        
        let pageController = SFPageSectionsViewController(viewControllers: controllers)
//        pageController.pageBar.buttonsTintColor = .red
        pageController.pageBar.useAdaptingWidth = false
        window?.rootViewController = pageController
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

