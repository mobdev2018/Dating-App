//
//  SliderViewCell.swift
//  Dots
//
//  Created by Sasha on 8/25/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class TBSlider: UISlider {
    
    /*open override func minimumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: .zero, size: CGSize(width: bounds.width, height: 4.0))
    }
    
    open override func maximumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: .zero, size: CGSize(width: bounds.width, height: 3.0))
    }*/
    
    /*open override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: .zero, size: CGSize(width: bounds.width, height: 14.0))
    }*/
}

class SliderViewCell: BasicProfileCell {
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var slider: TBSlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        slider.setMinimumTrackImage(UIImage(named: "sliderRound")?.stretchableImage(withLeftCapWidth: 1, topCapHeight: 2), for: .normal)
        slider.setMaximumTrackImage(UIImage(named: "sliderSmall"), for: .normal)
        
        slider.setThumbImage(UIImage(named: "slider-circle"), for: .normal)
        slider.layer.cornerRadius = 4.0
        slider.clipsToBounds = true
    }
    
    @IBAction func onValue() {
        valueLbl.text = String(describing: "\(Int(slider.value * 90) + 10) Mi")
    }
}
