//
//  ProfileConfManager.swift
//  Flip
//
//  Created by Sasha on 2/22/17.
//  Copyright © 2017 Qbits. All rights reserved.
//

import Foundation

let kUserLogInOutNotification = "kUserLogInOutNotification"

class ProfileManager: NSObject {
    static var shared = ProfileManager()
    
    // Profile data
    var profile: Profile = Profile(JSON: [:])
    
    override init() {
        super.init()
        self.update()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// Public methods
extension ProfileManager {
    func update() {
        profile.read()
    }
    
    func logOut() {
        profile = Profile(JSON: [:])
        saveState()
    }
    
    func logIn() {
        update()
        
        profile.read()
    }
    
    func saveState() {
        profile.save()
    }
}
