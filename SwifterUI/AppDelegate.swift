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

        let controller = SFTabBarController()
        let mainController = ViewController(automaticallyAdjustsColorStyle: false)
        let firstTab = SFTabBarItem(title: "Prueba",
                                    image: SFAssets.imageOfPlus.withRenderingMode(.alwaysTemplate), tag: 0)
        firstTab.animation = .flip
        mainController.tabBarItem = firstTab
        let secondController = ViewController(automaticallyAdjustsColorStyle: true)
        let secondTab = SFTabBarItem(title: "Prueba",
                                     image: SFAssets.imageOfArrowDown.withRenderingMode(.alwaysTemplate), tag: 1)
        secondTab.animation = .rotate
        secondController.tabBarItem = secondTab
        controller.viewControllers = [mainController, secondController]
        controller.selectedViewController = mainController
        window?.rootViewController = controller
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

