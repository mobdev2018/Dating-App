//
//  Ad.swift
//  Dots
//
//  Created by Sasha on 8/25/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation

struct Ad {
    var imageUrl: String?
    var title: String?
    var url: String?
    
    init (JSON: [String: Any]) {
        imageUrl = JSON["imageUrl"] as? String
        title = JSON["title"] as? String
        url = JSON["url"] as? String
    }
}
