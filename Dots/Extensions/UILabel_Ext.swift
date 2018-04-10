//
//  UILabel_Ext.swift
//  Dots
//
//  Created by Sasha on 8/4/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

extension UILabel {
    func setAttrTitle(_ title: String) {
        setTxt(title, with: 3.5, color: .cellLabelColor)
    }
    
    func setProfileName(_ title: String) {
        let attrString = NSMutableAttributedString(string: title)
        let range = NSRange(location: 0, length: attrString.length)
        attrString.addAttribute(NSAttributedStringKey.kern, value: 1.3, range: range)
        attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.profileDetailsNameColor, range: range)
        attrString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "FiraSans-Bold", size: 17)!, range: range)
        attributedText = attrString
    }
    
    func setHeaderCellTitle(_ title: String) {
        setTxt(title, with: 1.5, color: .headerFooterTextColor)
    }
    func setNavigationTitle(_ title: String) {
        let attrString = NSMutableAttributedString(string: title)
        let range = NSRange(location: 0, length: attrString.length)
        attrString.addAttribute(NSAttributedStringKey.kern, value: 3.5, range: range)
        attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.navBarTitleColor, range: range)
        attrString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "FiraSans-Bold", size: 16)!, range: range)
        attributedText = attrString
    }
    
    func setTxt(_ text: String, with spacing: Double, color: UIColor) {
        let attrString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: attrString.length)
        attrString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: range)
        attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: color , range: range)
        attributedText = attrString
    }
}


extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let screenRect = UIScreen.main.bounds
        return CGSize(width: screenRect.size.width, height: 50)
    }
}
