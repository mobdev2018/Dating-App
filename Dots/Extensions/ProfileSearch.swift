//
//  ProfileSearch.swift
//  Dots
//
//  Created by Sasha on 10/7/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation

func isMale(_ str: String) -> Bool {
    return str == "male"
}

func isFemale(_ str: String) -> Bool {
    return str == "female"
}

extension Profile {
    func isValid(for filter: Filter) -> Bool {
        if let age = self.age {
            if age < filter.minAge || age > filter.maxAge {
                return false
            }
        }
        
        if let height = self.height {
            if height < filter.minHeight || height > filter.maxHeight {
                return false
            }
        }
        
        if let gender = self.gender, let filterGeender = filter.gender {
            if filterGeender != "Both" {
                if filterGeender == "Only Men" && isFemale(gender) {
                    return false
                }
                
                if filterGeender == "Only Women" && isMale(gender) {
                    return false
                }
            }
        }
        
        if let filterPolic = filter.politics {
            if filterPolic != "Other" {
                if let politic = self.politics {
                    if politic != filterPolic {
                        return false
                    }
                } else {
                    return false
                }
            }
            
        }
        
        if let filterPolic = filter.familyPlans {
            if filterPolic != "Prefer not to say" {
                if let politic = self.familyPlans {
                    if politic != filterPolic {
                        return false
                    }
                } else {
                    return false
                }
            }
        }
        
        if let filterZodiac = filter.zodiacSign {
            if filterZodiac != "Prefer not to say" {
                if let politic = self.zodiacSign {
                    if politic != filterZodiac {
                        return false
                    }
                } else {
                    return false
                }
            }
        }
        
        if let filterPolic = filter.religioulsBeliefs {
            if filterPolic != "Other" {
                if let politic = self.religioulsBeliefs {
                    if politic != filterPolic {
                        return false
                    }
                } else {
                    return false
                }
            }
        }
        
        // Distance
        
        // Interest
        if let interested = self.interestedIn,let filterInterest = filter.interestedIn {
         if isSameInterestedIn(interested: interested, filterInterest: filterInterest) == false {
            return false
         }
        }
            
        
        if var key = filter.keyword {
            key = key.lowercased()
            if let res = work?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }
            
            if let res = education?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }
            
            if let res = familyPlans?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }
            
            if let res = politics?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }
            
            if let res = ethnicity?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }
            
            if let res = religioulsBeliefs?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }
            
            if let res = zodiacSign?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }
            
            /*if let res = music?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }
            
            if let res = movies?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }
            
            if let res = tvShows?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }
            
            if let res = sportsTeams?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }
            
            if let res = books?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }*/
            
            if let res = about?.lowercased() {
                if let _ = res.range(of: key) {
                    return true
                }
            }
            
            return false
        }
        
        if let selfTags = tags, let filterTags = filter.tags {
            let set1:Set<String> = Set(selfTags)
            let set2:Set<String> = Set(filterTags)
            
            return set1.intersection(set2).count > 0
        }
        
        return true
    }
}

    func isSameInterestedIn(interested: [Int], filterInterest: [Int]/*, filterGender:String, profileGender: String*/) -> Bool {
        if interested.contains(6) && filterInterest.contains(6) {
            return true
        } else {
            // casual
            let isFilterInCasualMan = filterInterest.contains(0) == true
            let isFilterInCasualWoman = filterInterest.contains(1) == true
            let isFilterInCasualBoth = filterInterest.contains(2) == true
            
            let isProfileInCasualMan = interested.contains(0) == true
            let isProfileInCasualWoman = interested.contains(1) == true
            let isProfileInCasualBoth = interested.contains(2) == true
            
            if (isFilterInCasualMan && (isProfileInCasualMan || isProfileInCasualBoth)) || (isFilterInCasualWoman && (isProfileInCasualWoman || isProfileInCasualBoth)) {
                return true
            }
            
            if isFilterInCasualBoth  && isProfileInCasualBoth {
                return true
            }
            
            let isFilterInSeriousMan = filterInterest.contains(3) == true
            let isFilterInSeriousWoman = filterInterest.contains(4) == true
            let isFilterInSeriousBoth = filterInterest.contains(5) == true
            
            let isProfileInSeriousMan = interested.contains(3) == true
            let isProfileInSeriousWoman = interested.contains(4) == true
            let isProfileInSeriousBoth = interested.contains(5) == true
            
            if (isProfileInSeriousMan && (isFilterInSeriousMan || isFilterInSeriousBoth)) || (isFilterInSeriousWoman && (isProfileInSeriousWoman || isProfileInSeriousBoth)) {
                return true
            }
            
            if isFilterInSeriousBoth  && isProfileInSeriousBoth {
                return true
            }
            
            return false
        }
    }


/*func isSameInterestedIn(interested: [Int], filterInterest: [Int], filterGender:String, profileGender: String) -> Bool {
    if interested.contains(6) && filterInterest.contains(6) {
        return true
    } else {
        // casual
        let isFilterInCasualMan = filterInterest.contains(0)
        let isFilterInCasualWoman = filterInterest.contains(1)
        let isFilterInCasualBoth = filterInterest.contains(2)
        
        let isProfileInCasualMan = interested.contains(0)
        let isProfileInCasualWoman = interested.contains(1)
        let isProfileInCasualBoth = interested.contains(2)
        
        if (isProfileInCasualMan && isMale(filterGender)) || (isProfileInCasualWoman && isFemale(filterGender)) || (isProfileInCasualBoth) {
            if (isFilterInCasualMan && isMale(profileGender)) || (isFilterInCasualWoman && isFemale(profileGender)) || (isFilterInCasualBoth) {
                return true
            }
        }
        
        let isFilterInSeriousMan = filterInterest.contains(3)
        let isFilterInSeriousWoman = filterInterest.contains(4)
        let isFilterInSeriousBoth = filterInterest.contains(5)
        
        let isProfileInSeriousMan = interested.contains(3)
        let isProfileInSeriousWoman = interested.contains(4)
        let isProfileInSeriousBoth = interested.contains(5)
        
        if (isProfileInSeriousMan && isMale(filterGender)) || (isProfileInSeriousWoman && isFemale(filterGender)) || (isProfileInSeriousBoth) {
            if (isFilterInSeriousMan && isMale(profileGender)) || (isFilterInSeriousWoman && isFemale(profileGender)) || (isFilterInSeriousBoth) {
                return true
            }
        }
        
        return false
    }
}*/
