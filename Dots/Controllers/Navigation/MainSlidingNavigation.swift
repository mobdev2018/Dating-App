//
//  MainSlidingNavigation.swift
//  Dots
//
//  Created by Sasha on 8/23/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class MainSlidingNavigation: SlidingPanelViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerPanel = UIStoryboard.getController(MainTabBarController.self)
        leftPanel = UIStoryboard.getController(LeftMenuViewController.self)
        
        view.bringSubview(toFront: leftPanelContainerView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showLeftPanel(animated: true)
    }
}
