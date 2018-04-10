//
//  Filter.swift
//  Dots
//
//  Created by Sasha on 8/24/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation

struct Filter {
    var tags: [String]?
    var keyword: String?
    
    var interestedIn: [Int]?
    
    var gender: String?
    var minAge: Int
    var maxAge: Int
    
    var minHeight: Int
    var maxHeight: Int
    
    var ethnicity: String?
    var religioulsBeliefs: String?
    var familyPlans: String?
    var zodiacSign: String?
    var personalityType: String?
    var politics: String?
    
    init (JSON: [String: Any]) {
        tags = JSON["tags"] as? [String]
        keyword = JSON["keyword"] as? String
        interestedIn = JSON["interestedIn"] as? [Int]
        
        gender = JSON["gender"] as? String
        if let minA = JSON["minAge"] as? Int  {
            minAge = minA
        } else {
            minAge = 0
        }
        if let maxA = JSON["maxAge"] as? Int {
            maxAge = maxA
        } else {
            maxAge = 0
        }
        
        
        // Personal
        if let minA = JSON["minHeight"] as? Int {
            minHeight = minA
        } else {
            minHeight = 0
        }
        if let maxA = JSON["maxHeight"] as? Int {
            maxHeight = maxA
        } else {
            maxHeight = 0
        }

        ethnicity = JSON["ethnicity"] as? String
        religioulsBeliefs = JSON["religioulsBeliefs"] as? String
        familyPlans = JSON["familyPlans"] as? String
        zodiacSign = JSON["zodiacSign"] as? String
        personalityType = JSON["personalityType"] as? String
        politics = JSON["politics"] as? String
    }
    
    func toJSON() -> [String: Any] {
        var result: [String: Any] = [:]
        
        if let tags = tags {
            result["tags"] = tags
        }
        
        if let res = gender {
            result["gender"] = res
        }
        
        if let res = keyword {
            result["keyword"] = res
        }
        
        result["minAge"] = minAge
        result["maxAge"] = maxAge
        
        // Personal
        result["minHeight"] = minHeight
        result["maxHeight"] = maxHeight
        
        if let res = interestedIn {
            result["interestedIn"] = res
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
        if let res = politics {
            result["politics"] = res
        }
        
        
        return result
    }
}

extension Filter {
    func valueFor(_ position: CellPosition) -> String? {
        switch position {
        case .gender:
            return gender
        case .searchGender:
            return gender
        case .searchAge:
            return "\(String(describing: minAge))-\(String(describing: maxAge))"
        case .searchHeight:
            return "\(String(describing: cmToFeet(cm: minHeight)))-\(String(describing: cmToFeet(cm: maxHeight)))"
        case .searchKeyword:
            return keyword
        
        case .searchPolitics:
            return politics
        case .searchReligious:
            return religioulsBeliefs
        case .searchFamily:
            return familyPlans
        case .searchZodiac:
            return zodiacSign
            
            
        default:
        return nil
        }
    }
    
    func sliderLowerValue(_ position: CellPosition) -> Double {
        switch position {
        case .searchAge:
            return Double(minAge)
        case .searchHeight:
            return Double(minHeight)
        default:
            return 0.0
        }
    }
    
    func sliderUpperValue(_ position: CellPosition) -> Double {
        switch position {
        case .searchAge:
            return Double(maxAge)
        case .searchHeight:
            return Double(maxHeight)
        default:
            return 0.0
        }
    }
    
    
    func minValueFor(_ position: CellPosition) -> Double {
        switch position {
        case .searchAge:
            return Double(FirebaseManager.shared.defaultPickers.ages.first!)!
        case .searchHeight:
            return Double(FirebaseManager.shared.defaultPickers.heights.first!)!
        default:
            return 0.0
        }
        
        /*slider.minimumValue = 140.0
        slider.stepValue = 1.0
        slider.maximumValue = 250.0
        slider.lowerValue = slider.minimumValue
        slider.upperValue = slider.maximumValue*/
    }
    
    func maxValueFor(_ position: CellPosition) -> Double {
        switch position {
        case .searchAge:
            return Double(FirebaseManager.shared.defaultPickers.ages.last!)!
        case .searchHeight:
            return Double(FirebaseManager.shared.defaultPickers.heights.last!)!
        default:
            return 0.0
        }
    }
    
    func selectedTags() -> [String] {
        if let tags = tags {
            return tags
        }
        return []
    }
}

extension Filter {
    mutating func apply(min: Any, max: Any, position: CellPosition) {
        switch position {
        case .searchAge:
            minAge = min as! Int
            maxAge = max as! Int
        case .searchHeight:
            minHeight = min as! Int
            maxHeight = max as! Int
        default:
            return
        }
    }
    
    mutating func apply(_ value: Any, position: CellPosition) {
        switch position {
        case .searchGender:
            if let gender = value as? String {
                self.gender = gender
                return
            }
        case .searchKeyword:
            if let keyword = value as? String {
                self.keyword = keyword
                return
            }
        case .searchPolitics:
            if let res = value as? String {
                self.politics = res
                return
            }
        case .searchFamily:
            if let res = value as? String {
                self.familyPlans = res
                return
            }
        case .searchReligious:
            if let res = value as? String {
                self.religioulsBeliefs = res
                return
            }
        case .searchZodiac:
            if let res = value as? String {
                self.zodiacSign = res
                return
            }
        default:
            print("nothing")
        }
    }
}

// MARK:- Validation
extension Filter {
    func isTagsEmpty() -> Bool {
        if let tags = tags {
            return tags.isEmpty
        }
        return true
    }
}
