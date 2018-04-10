//
//  FirebseManager.swift
//  Dots
//
//  Created by Sasha on 8/1/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()
    
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    var isConnected = false
    var defaultPickers: DefaultPickers = DefaultPickers()
    
    init() {
        self.databaseRef = Database.database().reference()
        self.storageRef = Storage.storage().reference()
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                self.isConnected = true
            } else {
                self.isConnected = false
            }
        })
    }
    
}

// User management
extension FirebaseManager {
    func imagePrefix() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func doesUserExists(with completion: @escaping(Bool, Profile?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        self.databaseRef.child(FirebaseKeys.users).child(uid).observeSingleEvent (of: .value, with: { (snapshot) in
            guard let json = snapshot.value as? [String: Any] else {
                completion(false, nil)
                return
            }
            
            completion(true, Profile(JSON: json))
        })
    }
}

// Default values 
extension FirebaseManager {
    func loadDefaultArrays(with  completion: @escaping(Bool) -> ()) {
        self.databaseRef.child(FirebaseKeys.defaultPickers).observeSingleEvent (of: .value, with: { (snapshot) in
            guard let json = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            self.defaultPickers = DefaultPickers(json: json)
            completion(true)
        })
    }
}

// Profile management
extension FirebaseManager {
    func uploadPhoto(data: Data, fileName: String, completion: @escaping (String?, Error?) -> ()) {
        let imagesRef = self.storageRef.child(fileName)
        let uploadTask = imagesRef.putData(data,
                                           metadata: nil) { (metadata, error) in
                                            completion(metadata?.downloadURL()?.absoluteString, error)
        }
        
        uploadTask.resume()
    }
    
    func update(profile: Profile) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //let key = self.databaseRef.child(FirebaseKeys.users).child(uid).key
        let recipeObj = profile.toJSON()
        self.databaseRef.child(FirebaseKeys.users).child(uid).setValue(recipeObj)
    }
    
    func getUser(with completion: @escaping(Bool, Profile?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        self.databaseRef.child(FirebaseKeys.users).child(uid).observeSingleEvent (of: .value, with: { (snapshot) in
            guard let json = snapshot.value as? [String: Any] else {
                completion(false, nil)
                return
            }
            
            let profile = Profile(JSON: json, userId: uid)
            completion(true, profile)
        })
    }
}

//
extension FirebaseManager {
    func addLike(userId: String, text: String, completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        self.databaseRef.child(FirebaseKeys.users).child(uid).child(FirebaseKeys.likes).child(userId).setValue(text) { (error, ref) in
            if error == nil {
                if !ProfileManager.shared.profile.likes.contains(userId) {
                    ProfileManager.shared.profile.likes.append(userId)
                }
                self.databaseRef.child(FirebaseKeys.users).child(userId).child(FirebaseKeys.matches).child(uid).setValue(text) { (error, ref) in
                    if error == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    func addLike(userId: String, completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        self.databaseRef.child(FirebaseKeys.users).child(uid).child(FirebaseKeys.likes).child(userId).setValue("_") { (error, ref) in
            if error == nil {
                if !ProfileManager.shared.profile.likes.contains(userId) {
                    ProfileManager.shared.profile.likes.append(userId)
                }
                self.databaseRef.child(FirebaseKeys.users).child(userId).child(FirebaseKeys.matches).child(uid).setValue("_") { (error, ref) in
                    if error == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    func dislike(userId: String, completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        self.databaseRef.child(FirebaseKeys.users).child(uid).child(FirebaseKeys.matches).child(userId).removeValue() { (error, ref) in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

// Ads
extension FirebaseManager {
    func downloadAds(completion: @escaping ([Ad]?) -> ()) {
        self.databaseRef.child(FirebaseKeys.ads).observeSingleEvent (of: .value, with: { (snapshot) in
            guard let json = snapshot.value as? NSArray else {
                completion(nil)
                return
            }
            var resultArray: [Ad] = []
            for value in json  {
                if let j = value as? [String: Any] {
                    let ad = Ad(JSON: j)
                    resultArray.append(ad)
                }
            }
            
            completion(resultArray)
        })
    }
}

// Search
extension FirebaseManager {
    func downloadUsers(completion: @escaping ([Profile]?) -> ()) {
        self.databaseRef.child(FirebaseKeys.users).observeSingleEvent (of: .value, with: { (snapshot) in
            guard let json = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            var uid = ""
            if let currentUID = Auth.auth().currentUser?.uid {
                uid = currentUID
            }
            var resultArray: [Profile] = []
            for (key, value) in json {
                if let j = value as? [String: Any] {
                    if key != uid {
                        var profile = Profile(JSON: j)
                        profile.userID = key
                        resultArray.append(profile)
                    }
                }
            }
            
            completion(resultArray)
        })
    }
}


// FAKE USER
extension FirebaseManager {
    
    func uploadFakeUser(id: String, profile: Profile) {
        let recipeObj = profile.toJSON()
        self.databaseRef.child(FirebaseKeys.users).child(id).setValue(recipeObj)
    }
}
