//
//  AppDelegate.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        Application.shared.configure(in: window)
        return true
    }
}
