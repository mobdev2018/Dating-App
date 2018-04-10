//
//  CollectionViews.swift
//  Dots
//
//  Created by Sasha on 8/12/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit


class PhotosCollectionView: UICollectionView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCells([AddPhotoCollectionCell.self,
                       PhotoCollectionCell.self])
    }
}

class TagsCollectionView: UICollectionView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCells([TagCollectionCell.self])
    }
}

