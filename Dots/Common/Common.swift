//
//  Common.swift
//  Dots
//
//  Created by Sasha on 10/1/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation

//// DEBUG
let isStaticLocation = false

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
