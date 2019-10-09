//
//  AppDelegate.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/9/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        guard let window = window else { return false }
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        
        return true
    }
}

