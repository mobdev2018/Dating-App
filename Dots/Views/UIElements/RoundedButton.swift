//
//  RoundedButton.swift
//  Dots
//
//  Created by Sasha on 8/3/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2.0
    }
}
