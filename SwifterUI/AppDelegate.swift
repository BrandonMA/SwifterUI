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
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
//        let dummyUsers = [
//            "Brandon": "Maldonado",
//            "Terra": "Clark",
//            "Marshall": "Kim",
//            "Alicia": "Woods",
//            "Loretta": "Lopez",
//            "Theodore": "Matthews",
//            "Don": "Grant",
//            "Troy": "Price",
//            "Jacqueline": "Shelton"
//        ]
        
        let brandon = SFUser(name: "Brandon", lastName: "Maldonado Alonso")
        brandon.profilePictureURL = "https://randomuser.me/api/portraits/men/75.jpg"
        
        let newContact = SFUser(name: "Terra", lastName: "Clark")
        newContact.profilePictureURL = "https://randomuser.me/api/portraits/men/86.jpg"
        brandon.addNew(contact: newContact)

        let newContact2 = SFUser(name: "name", lastName: "lastname")
        newContact2.profilePictureURL = "https://randomuser.me/api/portraits/men/87.jpg"
        brandon.addNew(contact: newContact2)
        
        let newContact3 = SFUser(name: "Terra", lastName: "Bi")
        newContact3.profilePictureURL = "https://randomuser.me/api/portraits/men/70.jpg"
        brandon.addNew(contact: newContact3)
        
        let chat = SFSingleChat(users: [brandon.identifier, newContact.identifier], messages: [], name: "\(brandon.name) \(newContact.lastName)")
        chat.currentUser = brandon
        chat.contact = newContact
        brandon.addNew(chat: chat)
        newContact.addNew(chat: chat)
        let message = SFMessage(senderIdentifier: brandon.identifier, chatIdentifier: chat.identifier)
        chat.addNew(message: message)
        
        window?.rootViewController = SFNavigationController(rootViewController: SFConversationsTableViewController(user: brandon))
        
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
