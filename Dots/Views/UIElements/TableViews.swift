//
//  TableViews.swift
//  Dots
//
//  Created by Sasha on 8/24/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class SetUpProfileTableView: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCells([TextFieldCell.self,
                       PhotosCell.self,
                       TagsCell.self,
                       ProfileTagsCell.self,
                       InterestedInCell.self])
        
        registerHeaderFooters([HeaderView.self])
    }
}

class ProfileTableView: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCells([PhotoProfileCell.self,
                       DetailsCell.self,
                       TagsCell.self])
    }
}

class SearchTableView: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        registerCells([TextFieldCell.self,
                       TagsCell.self,
                       SliderViewCell.self,
                       RangeSliderCell.self,
                       InterestedInCell.self])
        
        registerHeaderFooters([HeaderView.self])
    }
}

class SelectTagsTableView: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCells([SelectTagTableViewCell.self])
    }
}
