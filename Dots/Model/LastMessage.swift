//
//  LastMessage.swift
//  Flip
//
//  Created by Sasha on 3/1/17.
//  Copyright © 2017 Qbits. All rights reserved.
//

import Foundation


/*let kIdDef = "kIdDef"
let kNameDef = "kNameDefManager"
let kAgeDef = "kAgeDef""*/

class LastMessage : NSObject, NSCoding {
    var channelId: String = ""
    var text: String = ""
    var isRead: Bool = true
    var userId: String = ""
    
    init(channelId: String, text: String, isRead: Bool, userId: String) {
        self.channelId = channelId
        self.text = text
        self.isRead = isRead
        self.userId = userId
    }
    
    required init(coder decoder: NSCoder) {
        self.channelId = decoder.decodeObject(forKey: "channelId") as! String
        self.text = decoder.decodeObject(forKey: "text") as! String
        self.isRead = decoder.decodeBool(forKey: "isRead") as! Bool
        self.userId = decoder.decodeObject(forKey: "userId") as! String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.channelId, forKey: "channelId")
        aCoder.encode(self.text, forKey: "text")
        aCoder.encode(self.isRead, forKey: "isRead")
        aCoder.encode(self.userId, forKey: "userId")
    }
}
