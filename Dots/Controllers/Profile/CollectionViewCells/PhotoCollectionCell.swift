//
//  PhotoCollectionCell.swift
//  Dots
//
//  Created by Sasha on 8/7/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

protocol PhotoCollectionCellDelegate: class {
    func didPressDeletePhoto(at index: Int)
}

class PhotoCollectionCell: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView!
    
    weak var delegate: PhotoCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 10.0
    }
}

extension PhotoCollectionCell {
    @IBAction func onDelete() {
        delegate?.didPressDeletePhoto(at: tag)
    }
}
