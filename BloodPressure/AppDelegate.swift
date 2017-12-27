//
//  AppDelegate.swift
//  BloodPressure
//
//  Created by Aleksander Maj on 21/12/2017.
//  Copyright © 2017 Aleksander Maj. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var app: App?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        app = App(application: application, window: window)
        return true
    }
}
