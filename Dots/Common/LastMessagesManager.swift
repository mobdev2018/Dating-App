//
//  ChatManager.swift
//  Flip
//
//  Created by Sasha on 3/1/17.
//  Copyright © 2017 Qbits. All rights reserved.
//

import Foundation

let kLastMessangerWasRunO = "kLastMessangerWasRunO"
let kLastMessagesDef = "kLastMessagesDef"

class LastMessagesManager {
    static var shared = LastMessagesManager()
    
    var messages: [LastMessage] = []
    var isUsed: Bool = false
}

// MARK:- Public methods
extension LastMessagesManager {
    func save() {
        let defaults = UserDefaults.standard
        
        defaults.setValue(isUsed, forKey: kLastMessangerWasRunO)
        defaults.setValue(NSKeyedArchiver.archivedData(withRootObject: messages), forKey: kLastMessagesDef)
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let _ = defaults.value(forKey: kLastMessangerWasRunO) as? Bool {
            isUsed = true
        }
        
        if let defData = defaults.data(forKey: kLastMessagesDef) {
            if let data = NSKeyedUnarchiver.unarchiveObject(with: defData) {
                if let arr = data as? [LastMessage] {
                    messages = arr
                }
            }
        }
    }
    
    func clear() {
        messages = []
        save()
    }
    
    func hasMessage(for channelId: String) -> LastMessage? {
        for m in messages {
            if m.channelId == channelId {
                return m
            }
        }
        return nil
    }
    
    func addNew(lastMessage: LastMessage) {
        if hasMessage(for: lastMessage.channelId) == nil {
            messages.append(lastMessage)
        } else {
            var i = 0
            for j in 0..<messages.count {
                if messages[j].channelId == lastMessage.channelId {
                    i = j
                }
            }
            messages[i] = lastMessage
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessagesReceived), object: nil)
        save()
        AppDelegate.shared.changeBadge()
    }
    
    func hasUnread() -> Bool {
        for msg in messages {
            if !msg.isRead {
                return true
            }
        }
        
        return false
    }
}
