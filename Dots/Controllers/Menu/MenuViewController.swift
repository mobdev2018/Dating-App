//
//  MenuViewController.swift
//  Dots
//
//  Created by Sasha on 8/23/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit
import SafariServices

class MenuViewController: UIViewController {
    @IBOutlet var menuLbl: UILabel! {
        didSet {
            menuLbl.setNavigationTitle("MENU")
        }
    }
}

// MARK:- Actions
extension MenuViewController {
    @IBAction func onClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearch() {
        dismiss(animated: true, completion: nil)
        if let tabBarController = self.presentingViewController as? UITabBarController {
            tabBarController.selectedIndex = 0
        }
    }
    
    @IBAction func onTerms() {
        dismiss(animated: false) {
            AppDelegate.shared.onTerms()
        }
    }
    
    @IBAction func onFeedback() {
        dismiss(animated: true, completion: nil)
        AppDelegate.shared.onFeedback()
    }
    
    @IBAction func onLogOut() {
        NavigationCoordinator.presentWelcomeScreen()
        AppDelegate.shared.logOut()
    }
}
