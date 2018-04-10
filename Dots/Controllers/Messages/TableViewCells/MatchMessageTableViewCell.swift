//
//  MatchMessageTableViewCell.swift
//  Dots
//
//  Created by Sasha on 9/27/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

extension UIColor {
    open class var defaultCircleColor: UIColor {
        return UIColor(hex: "BD86A2")
    }
    
    open class var unreadCircleColor: UIColor {
        return UIColor(hex: "77c4d3")
    }
    
    open class var defaultNameColor: UIColor {
        return .black
    }
    
    open class var unreadNameColor: UIColor {
        return UIColor(hex: "77c4d3")
    }
    
    open class var defaultMessageColor: UIColor {
        return .lightGray
    }
    
    open class var unreadMessageColor: UIColor {
        return .black
    }
}

class MatchMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var circleBackView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var unreadImgView: UIImageView!
    @IBOutlet weak var unreadImgWidthConstraint: NSLayoutConstraint!
}

// MARK:-
extension MatchMessageTableViewCell {
    
}
