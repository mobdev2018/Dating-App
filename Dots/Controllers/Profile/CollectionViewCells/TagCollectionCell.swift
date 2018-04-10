//
//  TagCollectionCell.swift
//  Dots
//
//  Created by Sasha on 8/12/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class TagCollectionCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    
    var isClickable: Bool = false {
        didSet {
            if isClickable {
                
            } else {
                
            }
        }
    }
    
    var isClicked: Bool = false {
        didSet {
            if isClicked {
                nameLbl.backgroundColor = .selectedTagBackgroundColor
                nameLbl.textColor = .white
            } else {
                nameLbl.backgroundColor = .clear
                nameLbl.textColor = .black
            }
        }
    }
}
