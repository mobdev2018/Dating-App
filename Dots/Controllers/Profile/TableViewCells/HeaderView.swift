//
//  HeaderView.swift
//  Dots
//
//  Created by Sasha on 8/8/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func onHeader(_ index: Int)
}

class HeaderView: UITableViewHeaderFooterView {
    @IBOutlet var nameLbl: UILabel!
    weak var delegate: HeaderViewDelegate?
}

// Actions
extension HeaderView {
    @IBAction func onHeader() {
        delegate?.onHeader(tag)
    }
}
