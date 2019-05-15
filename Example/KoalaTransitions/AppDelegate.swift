//
//  AppDelegate.swift
//  KoalaTransitions
//
//  Created by nick@fuzzproductions.com on 05/13/2019.
//  Copyright (c) 2019 nick@fuzzproductions.com. All rights reserved.
//

import KoalaTransitions
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white

        let tabController = UITabBarController()
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()

        let navVC = AnimatedNavigationController(rootViewController: FirstViewController())
        navVC.transitioner = Transitioner(animator: SlideAnimator(direction: .fromBottomToTop))
        navVC.setTransitioningDelegateToTransitioner()
        tabController.setViewControllers([ListViewController(), ViewController(), navVC], animated: true)

        return true
    }
}
