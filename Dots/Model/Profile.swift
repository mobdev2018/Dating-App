//
//  Profile.swift
//  Dots
//
//  Created by Sasha on 8/6/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation

struct Profile {
    var userID: String
    
    var interestedIn: [Int]?
    var about: String?
    
    var photos: [String]?
    var name: String?
    var gender: String?
    var age: Int?
    var work: String?
    var education: String?
    
    var height: Int?
    var ethnicity: String?
    var religioulsBeliefs: String?
    var familyPlans: String?
    var zodiacSign: String?
    var personalityType: String?
    
    var music: [String]?
    var movies: [String]?
    var tvShows: [String]?
    var books: [String]?
    var sportsTeams: [String]?
    
    
    var politics: String?
    var tags: [String]?
    
    var likes: [String]
    var initialMessages: [String]
    var matches: [String]
    var blocked: [String]
    
    init (JSON: [String: Any], userId: String? = "123") {
        userID = userId!
        
        interestedIn = JSON["interestedIn"] as? [Int]
        about = JSON["about"] as? String
        photos = JSON["photos"] as? [String]
        name = JSON["name"] as? String
        gender = JSON["gender"] as? String
        age = JSON["age"] as? Int
        work = JSON["work"] as? String
        education = JSON["education"] as? String
        
        // Personal
        height = JSON["height"] as? Int
        ethnicity = JSON["ethnicity"] as? String
        religioulsBeliefs = JSON["religioulsBeliefs"] as? String
        familyPlans = JSON["familyPlans"] as? String
        zodiacSign = JSON["zodiacSign"] as? String
        personalityType = JSON["personalityType"] as? String
        
        // Interests
        music = JSON["music"] as? [String]
        movies = JSON["movies"] as? [String]
        tvShows = JSON["tvShows"] as? [String]
        books = JSON["books"] as? [String]
        sportsTeams = JSON["sportsTeams"] as? [String]
        
        //Affiliations
        politics = JSON["politics"] as? String
        
        
        //Profile tags
        tags = JSON["tags"] as? [String]
        
        //
        likes = []
        
        if let res = JSON["likes"] as? [String: String] {
            for (key,_) in res {
                likes.append(key)
            }
        }
        matches = []
        initialMessages = []
        if let res = JSON["matches"] as? [String: String] {
            for (key,value) in res {
                matches.append(key)
                if value != nil {
                    initialMessages.append(value)
                }
            }
        }
        
        blocked = []
        if let res = JSON["blocked"] as? [String: String] {
            for (_,value) in res {
                blocked.append(value)
            }
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        
        defaults.setValue(interestedIn, forKey: "interestedIn")
        
        defaults.setValue(about, forKey: "about")
        defaults.setValue(userID, forKey: "userID")
        defaults.setValue(photos, forKey: "photos")
        defaults.setValue(name, forKey: "name")
        defaults.setValue(gender, forKey: "gender")
        defaults.setValue(age, forKey: "age")
        defaults.setValue(work, forKey: "work")
        defaults.setValue(education, forKey: "education")
        
        // Personal
        defaults.setValue(height, forKey: "height")
        defaults.setValue(ethnicity, forKey: "ethnicity")
        defaults.setValue(religioulsBeliefs, forKey: "religioulsBeliefs")
        defaults.setValue(familyPlans, forKey: "familyPlans")
        defaults.setValue(zodiacSign, forKey: "zodiacSign")
        defaults.setValue(personalityType, forKey: "personalityType")
        
        // Interests
        defaults.setValue(music, forKey: "music")
        defaults.setValue(movies, forKey: "movies")
        defaults.setValue(tvShows, forKey: "tvShows")
        defaults.setValue(books, forKey: "books")
        
        //Affiliations
        defaults.setValue(politics, forKey: "politics")
        defaults.setValue(sportsTeams, forKey: "sportsTeams")
        
        //Profile tags
        defaults.setValue(tags, forKey: "tags")
        
        defaults.setValue(likes, forKey: "likes")
        defaults.setValue(likes, forKey: "initialMessages")
        defaults.setValue(matches, forKey: "matches")
        defaults.setValue(blocked, forKey: "blocked")
    }
    
    mutating func read() {
        let defaults = UserDefaults.standard
        
        
        if let usId = defaults.object(forKey: "userID") as? String {
            userID = usId
        }
        
        interestedIn = defaults.object(forKey: "interestedIn") as? [Int]
        about = defaults.object(forKey: "about") as? String
        
        photos = defaults.object(forKey: "photos") as? [String]
        name = defaults.object(forKey: "name") as? String
        gender = defaults.object(forKey: "gender") as? String
        age = defaults.object(forKey: "age") as? Int
        work = defaults.object(forKey: "work") as? String
        education = defaults.object(forKey: "education") as? String
        
        height = defaults.object(forKey: "height") as? Int
        ethnicity = defaults.object(forKey: "ethnicity") as? String
        religioulsBeliefs = defaults.object(forKey: "religioulsBeliefs") as? String
        familyPlans = defaults.object(forKey: "familyPlans") as? String
        zodiacSign = defaults.object(forKey: "zodiacSign") as? String
        personalityType = defaults.object(forKey: "personalityType") as? String
 
        music = defaults.object(forKey: "music") as? [String]
        movies = defaults.object(forKey: "movies") as? [String]
        tvShows = defaults.object(forKey: "tvShows") as? [String]
        books = defaults.object(forKey: "books") as? [String]
        sportsTeams = defaults.object(forKey: "sportsTeams") as? [String]
        
        politics = defaults.object(forKey: "politics") as? String
        
        tags = defaults.object(forKey: "tags") as? [String]
        
        if let res = defaults.object(forKey: "likes") as? [String] {
            likes = res
        } else {
            likes = []
        }
        
        if let res = defaults.object(forKey: "initialMessages") as? [String] {
            initialMessages = res
        } else {
            initialMessages = []
        }
        
        if let res = defaults.object(forKey: "matches") as? [String] {
            matches = res
        } else {
            matches = []
        }
        if let res = defaults.object(forKey: "blocked") as? [String] {
            blocked = res
        } else {
            blocked = []
        }
    }
    
    func toJSON() -> [String: Any] {
        var result: [String: Any] = [:]
        
        if let res = photos {
            result["photos"] = res
        }
        
        if let res = interestedIn {
            result["interestedIn"] = res
        }
        
        if let res = name {
            result["name"] = res
        }
        
        if let res = about {
            result["about"] = res
        }
        
        if let res = gender {
            result["gender"] = res
        }
        
        if let res = age {
            result["age"] = res
        }
        if let res = work {
            result["work"] = res
        }
        if let res = education {
            result["education"] = res
        }
        // Personal
        if let res = height {
            result["height"] = res
        }
        if let res = ethnicity {
            result["ethnicity"] = res
        }
        if let res = religioulsBeliefs {
            result["religioulsBeliefs"] = res
        }
        if let res = familyPlans {
            result["familyPlans"] = res
        }
        if let res = zodiacSign {
            result["zodiacSign"] = res
        }
        if let res = personalityType {
            result["personalityType"] = res
        }
        // Interests
        if let res = music {
            result["music"] = res
        }
        if let res = movies {
            result["movies"] = res
        }
        if let res = tvShows {
            result["tvShows"] = res
        }
        if let res = books {
            result["books"] = res
        }
        //Affiliations
        if let res = politics {
            result["politics"] = res
        }
        if let res = sportsTeams {
            result["sportsTeams"] = res
        }
        // Profile Tags
        if let tags = tags {
            result["tags"] = tags
        }
        
        //result["likes"] = likes
        //result["matches"] = matches
        //result["blocked"] = blocked
        
        return result
    }
}

//MARK: - Validation
extension Profile {
    func isValid() -> (Bool, String?) {
        guard name != nil else {
            return (false, "Please enter your Name")
        }
        
        guard age != nil else {
            return (false, "Please select your Age")
        }
        
        guard gender != nil else {
            return (false, "Please select your Gender")
        }
        
        return (true, nil)
    }
    
    func isTagsEmpty() -> Bool {
        if let tags = tags {
            return tags.isEmpty
        }
        return true
    }
    
    func selectedTags() -> [String] {
        if let tags = tags {
            return tags
        }
        return []
    }
    
    func getPhotos() -> [ProfilePhoto] {
        if let p = photos {
            var result: [ProfilePhoto] = []
            for photoPath in p {
                result.append(ProfilePhoto(path: photoPath))
            }
            return result
        }
        return []
    }
}

//
extension Profile {
    mutating func apply(_ value: Any, position: CellPosition) {
        switch position {
        case .name:
            if let name = value as? String {
                self.name = name
                return
            }
        case .gender:
            if let gender = value as? String {
                self.gender = gender
                return
            }
        case .age:
            if let age = Int(value as! String) {
                self.age = age
                return
            }
        case .work:
            if let work = value as? String {
                self.work = work
                return
            }
        case .education:
            if let education = value as? String {
                self.education = education
                return
            }
            
        // Personal
        case .height:
            if let height = Int(value as! String) {
                self.height = height
                return
            }
        case .ethnicity:
            if let ethnicity = value as? String {
                self.ethnicity = ethnicity
                return
            }
        case .religioulsBeliefs:
            if let religioulsBeliefs = value as? String {
                self.religioulsBeliefs = religioulsBeliefs
                return
            }
        case .familyPlans:
            if let familyPlans = value as? String {
                self.familyPlans = familyPlans
                return
            }
        case .zodiacSign:
            if let zodiacSign = value as? String {
                self.zodiacSign = zodiacSign
                return
            }
        case .personalityType:
            if let personalityType = value as? String {
                self.personalityType = personalityType
                return
            }
            
        // Interests
        case .music:
            if let music = value as? [String] {
                self.music = music
                return
            }
        case .movies:
            if let movies = value as? [String] {
                self.movies = movies
                return
            }
        case .tvShows:
            if let tvShows = value as? [String] {
                self.tvShows = tvShows
                return
            }
        case .books:
            if let books = value as? [String] {
                self.books = books
                return
            }
        case .sportsTeams:
            if let sportsTeams = value as? [String] {
                self.sportsTeams = sportsTeams
                return
            }
            
        // Affiliations
        case .politics:
            if let politics = value as? String {
                self.politics = politics
                return
            }
        
            
        default:
            print("nothing")
        }
    }
    
    func valueFor(_ position: CellPosition) -> String? {
        switch position {
        case .name:
            return name
        case .gender:
            return gender
        case .age:
            if let age = age {
                return String(describing: age)
            }
        case .work:
            return work
        case .education:
            return education
            
        // Personal
        case .height:
            if let height = height {
                return String(describing: height)
            }
        case .ethnicity:
            return ethnicity
        case .religioulsBeliefs:
            return religioulsBeliefs
        case .familyPlans:
            return familyPlans
        case .zodiacSign:
            return zodiacSign
        case .personalityType:
            return personalityType
            
        // Interests
        /*case .music:
            return music
        case .movies:
            return movies
        case .tvShows:
            return tvShows
        case .books:
            return books
        case .sportsTeams:
            return sportsTeams*/
            
            
        // Affiliations
        case .politics:
            return politics
        

        default:
            return nil
        }
        return nil
    }
}

// MARK:- Profile Details Public
extension Profile {
    func getAbout() -> [(String, String)] {
        var subsections: [(String, String)] = []
        if let s = about {
            subsections.append((s, ""))
        }
        return subsections
    }
    
    func getAffiliations() -> [(String, String)] {
        var subsections: [(String, String)] = []
        if let s = politics {
            subsections.append(("Political views: ", s))
        }
        
        if let s = ethnicity {
            subsections.append(("Ethnicity: ", s))
        }
        
        if let s = religioulsBeliefs {
            subsections.append(("Religious Beliefs: ", s))
        }
        
        if let s = zodiacSign {
            subsections.append(("Zodiac Sign: ", s))
        }
        
        return subsections
    }
    
    /*func getInterests() -> [(String, String)] {
        var subsections: [(String, String)] = []
        
        if let s = music {
            subsections.append(("Music: ", s))
        }
        
        if let s = movies {
            subsections.append(("Movies: ", s))
        }
        
        if let s = tvShows {
            subsections.append(("TV Shows: ", s))
        }
        
        if let s = sportsTeams {
            subsections.append(("Sports Teams: ", s))
        }
        
        if let s = books {
            subsections.append(("Books: ", s))
        }
        
        return subsections
    }*/
    
    func getTagsList() -> [(String, String)] {
        guard let rTags = tags else {
            return []
        }
        var s = ""
        for t in rTags {
            s += t
            s += "   "
        }
        
        return [("",s)]
    }
}
