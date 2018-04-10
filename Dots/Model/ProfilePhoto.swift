//
//  ProfilePhoto.swift
//  Dots
//
//  Created by Sasha on 8/7/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

struct ProfilePhoto {
    var path: String?
    var image: UIImage?
    
    init(path: String, image: UIImage) {
        self.path = path
        self.image = image
    }
    
    init(path: String) {
        self.path = path
    }
    
    init(image: UIImage) {
        self.image = image
    }
}
