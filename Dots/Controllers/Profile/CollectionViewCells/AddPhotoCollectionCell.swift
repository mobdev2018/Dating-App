//
//  AddPhotoCollectionCell.swift
//  Dots
//
//  Created by Sasha on 8/7/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

protocol AddPhotoCollectionCellDelegate: class {
    func didPressAddNewPhoto()
}

class AddPhotoCollectionCell: UICollectionViewCell {
    weak var delegate: AddPhotoCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //layer.shadowOffset = CGSize(width: 0, height: 0)
        //layer.shadowPath = CGPath(rect: self.bounds, transform: nil)
        //layer.shadowRadius = 1.0
        //layer.shadowOpacity = 0.4
    }
}

// MARK:- Actions
extension AddPhotoCollectionCell {
    @IBAction func onAdd() {
        delegate?.didPressAddNewPhoto()
    }
}
