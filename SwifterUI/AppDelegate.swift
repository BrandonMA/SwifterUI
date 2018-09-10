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
        let newContact = SFUser(name: "Terra", lastName: "Clark")
        newContact.profilePictureURL = "https://randomuser.me/api/portraits/men/86.jpg"
        brandon.addNewContact(newContact)
        SFSingleChat(currentUser: brandon, contact: newContact)
        
        let newContact2 = SFUser(name: "name", lastName: "lastname")
        newContact2.profilePictureURL = "https://randomuser.me/api/portraits/men/87.jpg"
        brandon.addNewContact(newContact2)
        SFGroupChat(currentUser: brandon, users: [newContact, newContact2], name: "Amigos")
        let chat = SFSingleChat(currentUser: brandon, contact: newContact2)
        
        DispatchQueue.delay(by: 3, dispatchLevel: .main) {
            let message = SFMessage(senderIdentifier: newContact2.identifier, text: "Hola", chatIdentifier: chat.identifier)
            chat.messages.append(message)
        }
                
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

