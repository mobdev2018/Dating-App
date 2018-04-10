//
//  Message.swift
//  Dots
//
//  Created by Sasha on 9/27/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation

struct Message {
    var text: String = ""
    var userID: String = ""
    
    init(text: String, userID: String) {
        self.text = text
        self.userID = userID
    }
    
    init(JSON: [String: Any]) {
        self.text = JSON["text"] as! String
        self.userID = JSON["userID"] as! String
    }
    
    func isMe(id: String) -> Bool {
        return userID == id
    }
}

extension Message {
    func toJSON() -> [String: Any] {
        var result: [String: Any] = [:]
        result["text"] = text
        result["userID"] = userID
        return result
    }
}
