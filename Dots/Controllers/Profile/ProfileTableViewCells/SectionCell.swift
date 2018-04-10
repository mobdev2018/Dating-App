//
//  SectionCell.swift
//  Dots
//
//  Created by Sasha on 9/27/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class SubsectionView: UIView {
    var nameLbl: UILabel!
    var infoLbl: UILabel!
}

class SectionCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var arrowImgView: UIImageView!
    
    var subsections: [SubsectionView] = []
    
    
    func height() -> CGFloat {
        return 120.0
    }
}
