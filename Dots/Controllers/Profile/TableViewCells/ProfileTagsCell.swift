//
//  ProfileTagsCell.swift
//  Dots
//
//  Created by Sasha on 12/5/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class ProfileTagsCell: BasicProfileCell {
    @IBOutlet weak var collectionView: TagsCollectionView!
    
    var isEmpty: Bool = false {
        didSet {
            collectionView.isHidden = isEmpty
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showTopSeparatorView = false
    }
}
