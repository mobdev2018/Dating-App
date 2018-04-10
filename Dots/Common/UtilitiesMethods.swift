//
//  UtilitiesMethods.swift
//  Dots
//
//  Created by Sasha on 8/26/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation

func cmToFeet(cm: Float) -> String {
    let inch_in_cm: Float = 2.54
    let numOfInches = Int(roundf(cm / inch_in_cm))
    let feet: Int = numOfInches / 12
    let inches: Int = numOfInches % 12
    return "\(feet)'\(inches)\""
}

func cmToFeet(cm: Double) -> String {
    let inch_in_cm: Double = 2.54
    let numOfInches = Int(roundf(Float(cm / inch_in_cm)))
    let feet: Int = numOfInches / 12
    let inches: Int = numOfInches % 12
    return "\(feet)'\(inches)\""
}

func cmToFeet(cm: Int) -> String {
    let inch_in_cm: Double = 2.54
    let numOfInches = Int(roundf(Float(Double(cm) / inch_in_cm)))
    let feet: Int = numOfInches / 12
    let inches: Int = numOfInches % 12
    return "\(feet)'\(inches)\""
}
