//
//  Colors.swift
//  Dots
//
//  Created by Sasha on 8/4/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    open class var cellLabelColor: UIColor {
        return UIColor(hex: "77c4d3")
    }
    
    open class var cellSeparatorColor: UIColor {
        return UIColor(hex: "C8C9C9")
    }
    
    open class var cellDoneButton: UIColor {
        return UIColor(hex: "BD86A2")
    }
    
    open class var headerFooterTextColor: UIColor {
        return UIColor(hex: "BD86A2")
    }
    
    open class var navBarTitleColor: UIColor {
        return UIColor(hex: "404040")
    }
    
    open class var navBarSeparatorColor: UIColor {
        return UIColor(hex: "C8C9C9")
    }
    
    open class var profileDetailsNameColor: UIColor {
        return UIColor(hex: "77C4D3")
    }
    
    
    // slider
    open class var sliderLabelColor: UIColor {
        return UIColor(hex: "C8C9C9")
    }
    
    //MARK:- Tags Cells
    open class var selectedTagBackgroundColor: UIColor {
        return UIColor(hex: "BD86A2")
    }
    
    open class var defaultTagFontColor: UIColor {
        return UIColor(hex: "C8C9C9")
    }
    
    //MARK:- MATCHES
    open class var selectedMatchColor: UIColor {
        return UIColor(hex: "BD86A2")
    }
    
    open class var notSelectedMatchColor: UIColor {
        return UIColor(hex: "F7F3F6")
    }
}
