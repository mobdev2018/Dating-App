//
//  TableViewCell_Ext.swift
//  Dots
//
//  Created by Sasha on 8/4/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

extension UIView {
    class func loadNib() -> UINib {
        return UINib(nibName: self.typeName, bundle: Bundle.main)
    }
}

extension UITableView {
    func registerCells(_ cellsTypes: [UITableViewCell.Type]) {
        for cell in cellsTypes {
            register(cell.loadNib(), forCellReuseIdentifier: cell.typeName)
        }
    }
    
    func registerHeaderFooters(_ cellsTypes: [UITableViewHeaderFooterView.Type]) {
        for cell in cellsTypes {
            register(cell.loadNib(), forHeaderFooterViewReuseIdentifier: cell.typeName)
        }
    }
}

extension UICollectionView {
    func registerCells(_ cellsTypes: [UICollectionViewCell.Type]) {
        for cell in cellsTypes {
            register(cell.loadNib(), forCellWithReuseIdentifier: cell.typeName)
        }
    }
}
