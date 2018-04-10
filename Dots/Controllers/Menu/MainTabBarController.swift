//
//  MainTabBarController.swift
//  Dots
//
//  Created by Sasha on 8/24/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundImage = UIImage(named: "tab-bar")
        tabBar.clipsToBounds = true
        
        setBarItem(imageName: "tabbar-search", at: 0)
        setBarItem(imageName: "tabbar-chat", at: 1)
        setBarItem(imageName: "tabbar-cards", at: 2)
        setBarItem(imageName: "tabbar-profile", at: 3)
    }
    
    func setBarItem(imageName: String, at position: Int) {
        if let items = tabBar.items {
            if items.count > position {
                items[position].selectedImage = UIImage (named: "\(imageName)-active")?.withRenderingMode(.alwaysOriginal)
                items[position].image = UIImage (named: imageName)?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
}

class MainTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = tabBarHeight
        return sizeThatFits
    }
}
