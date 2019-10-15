//
//  AppCoordinator.swift
//  OnboardingProject
//
//  Created by Polina Hill on 10/9/19.
//  Copyright © 2019 Polina Hill. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {
    
    let window: UIWindow
    let rootViewController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
    }
    
    func start() {
        let profilesViewController = ProfilesViewController()
        rootViewController.pushViewController(profilesViewController, animated: true)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
