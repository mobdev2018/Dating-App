//
//  RangeSliderCell.swift
//  Dots
//
//  Created by Sasha on 8/26/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class RangeSliderCell: BasicProfileCell {
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var rangeSlider: NHRangeSlider!
    
    @IBAction func onValueChanged(_ sender: Any) {
        if let cellDelegate = delegate {
            cellDelegate.didChange(minValue: Int(rangeSlider.lowerValue), maxValue: Int(rangeSlider.upperValue), position: positon)
            valueLbl.text = cellDelegate.minMaxFor(positon)
        }
    }
}
