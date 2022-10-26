//
//  AppDelegate.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = MoviesViewController()
        
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        return true
    }

}
