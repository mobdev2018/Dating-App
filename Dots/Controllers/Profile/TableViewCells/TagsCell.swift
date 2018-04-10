//
//  TagsCell.swift
//  Dots
//
//  Created by Sasha on 8/12/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class TagsCell: BasicProfileCell {
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
