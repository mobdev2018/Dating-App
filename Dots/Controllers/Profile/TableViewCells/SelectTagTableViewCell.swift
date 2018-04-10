//
//  SelectTagsTableViewCell.swift
//  Dots
//
//  Created by Sasha on 8/12/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class SelectTagTableViewCell: UITableViewCell {
    @IBOutlet weak var tagLbl: UILabel!
    
    var isPicked: Bool = false {
        didSet {
            self.tagLbl?.textColor = isPicked ? .cellDoneButton: .black
        }
    }
}
