//
//  DetailsCell.swift
//  Dots
//
//  Created by Sasha on 10/6/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class ProfileDetailsView: UIView {
    var labels: [UILabel] = []
    
    var totalHeight = CGFloat(0.0)
    var width = CGFloat(0.0)
    
    func setLabels(textsDict: [(String, String)]) {
        for label in labels {
            label.removeFromSuperview()
        }
        labels = []
        
        
        var rect = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 10.0)
        
        for (left, right) in textsDict {
            let leftString = NSMutableAttributedString(
                string: left,
                attributes: [NSAttributedStringKey.font:UIFont(
                    name: "FiraSans-Regular",
                    size: 14.0)!])
            
            
            let rightString = NSMutableAttributedString(
                string: right,
                attributes: [NSAttributedStringKey.font:UIFont(
                    name: "FiraSans-Bold",
                    size: 14.0)!])
            
            leftString.append(rightString)
            
            let label = UILabel(frame: rect)
            if self.width == 0.0 {
                label.preferredMaxLayoutWidth = self.bounds.size.width
            } else {
                label.preferredMaxLayoutWidth = self.width
            }
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            
            
            //label.backgroundColor = .green
            label.attributedText = leftString
            
            addSubview(label)
            label.sizeToFit()
            labels.append(label)
            rect.origin = CGPoint(x: rect.origin.x, y: rect.origin.y + label.frame.size.height)
        }
        
        totalHeight = rect.origin.y + self.frame.origin.y
    }
}

class DetailsCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailsView: ProfileDetailsView!
    
    func setName(_ name: String) {
        let attrString = NSMutableAttributedString(string: name)
        let range = NSRange(location: 0, length: attrString.length)
        attrString.addAttribute(NSAttributedStringKey.kern, value: 1.3, range: range)
        attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.profileDetailsNameColor, range: range)
        attrString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "FiraSans-Bold", size: 17)!, range: range)
        nameLbl.attributedText = attrString
    }
}
