//
//  AppDelegate.swift
//  CoffeeList
//
//  Created by Christopher Szatmary on 2016-06-19.
//  Copyright © 2016 SzatmaryInc. All rights reserved.
//

import SwiftySweetness

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(rootViewController: MenuViewController())
        return true
    }
}

