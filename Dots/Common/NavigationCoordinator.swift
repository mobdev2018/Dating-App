//
//  NavigationCoordinator.swift
//  Dots
//
//  Created by Sasha on 8/3/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation
import UIKit

class NavigationCoordinator {
    static let sharedInstance = NavigationCoordinator()
    
    class func presentWelcomeScreen() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let rootWindow = appDelegate.window else { return }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeNC = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeNavigationController") as! UINavigationController
        rootWindow.rootViewController = welcomeNC
        
    }
    
    class func createProfile() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let rootWindow = appDelegate.window else { return }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = mainStoryboard.instantiateViewController(withIdentifier: "SetUpNavigation") as! UINavigationController
        rootWindow.rootViewController = mainTabBarController
    }
    
    class func presentMainTabBar() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let rootWindow = appDelegate.window else { return }
        rootWindow.rootViewController = UIStoryboard.getController(MainTabBarController.self)
        AppDelegate.shared.setUpEverything()
    }
}
