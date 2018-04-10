//
//  RoundView.swift
//  Dots
//
//  Created by Sasha on 9/27/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class RoundView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2.0
    }
}
