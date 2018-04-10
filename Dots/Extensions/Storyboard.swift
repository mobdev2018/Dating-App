//
//  Storyboard.swift
//  Dots
//
//  Created by Sasha on 8/12/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func getController(_ controller: UIViewController.Type) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: controller.typeName)
    }
}
