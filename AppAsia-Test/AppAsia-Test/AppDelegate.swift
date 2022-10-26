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
    var coordinator: Coordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            coordinator = MainCoordinator(window: window)
        }
        coordinator?.start()
        
        return true
    }

}
