//
//  LeftChatCell.swift
//  Dots
//
//  Created by Sasha on 9/27/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

extension UIColor {
    open class var myMessageBackgroundColor: UIColor {
        return UIColor(hex: "76C5D5")
    }
    
    open class var matchMessageBackgroundColor: UIColor {
        return UIColor(hex: "EDEEEF")
    }
}




class LeftChatCell: UITableViewCell {
    @IBOutlet var messagelbl: UILabel!
    @IBOutlet var messageBubbleView: UIView!
    @IBOutlet var bubbleImgView: UIImageView!
    
    @IBOutlet var leftConstraint: NSLayoutConstraint!
    @IBOutlet var rightConstraint: NSLayoutConstraint!
    
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var profileBackView: UIView!
    
    var isRotated: Bool = false
}
