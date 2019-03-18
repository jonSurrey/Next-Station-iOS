//
//  AppDelegate.swift
//  NextStation
//
//  Created by Jonathan Martins on 11/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController =  MainViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

