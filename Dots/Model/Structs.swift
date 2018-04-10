//
//  Structs.swift
//  Dots
//
//  Created by Sasha on 8/7/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation

enum CellType {
    case photos, text, interestedIn, tags, profileTags, slider, rangeSlider
}

enum CellPosition {
    case photos, name, gender, age, work, education, height, about, interestedIn, ethnicity, religioulsBeliefs, familyPlans, zodiacSign, personalityType, music, movies, tvShows, books, politics, sportsTeams, tags,
    searchKeyword, searchGender, searchDistance, searchAge, searchPolitics, searchReligious, searchFamily, searchZodiac, searchHeight, searchTags, none
}

func nameFor(position: CellPosition) -> String {
    switch position {
    case .photos:
        return "photos"
    case .interestedIn:
        return "interested in"
    case .about:
        return "about"
    case .name:
        return "name"
    case .gender:
        return "gender"
    case .age:
        return "age"
    case .work:
        return "work"
    case .education:
        return "education"
        
    // Personal
    case .height:
        return "height"
    case .ethnicity:
        return "ethnicity"
    case .religioulsBeliefs:
        return "religious beliefs"
    case .familyPlans:
        return "family plans"
    case .zodiacSign:
        return "zodiac sign"
    case .personalityType:
        return "personality type"
        
    // Interests
    case .music:
        return "favorite music"
    case .movies:
        return "favorite movies"
    case .tvShows:
        return "favorite tv shows"
    case .books:
        return "favorite books"
        
    // Affiliations
    case .politics:
        return "politic views"
    case .sportsTeams:
        return "favorite sports teams"
    case .tags:
        return "tags"
        
    // Search
    case .searchKeyword:
        return "Keyword"
    case .searchGender:
        return "gender"
    case .searchDistance:
        return "maximum distance"
    case .searchAge:
        return "age range"
    case .searchHeight:
        return "height range"
    
    case .searchPolitics:
        return "political views"
    
    case .searchReligious:
        return "religious beliefs"
    case .searchZodiac:
        return "zodiac sign"
    case .searchFamily:
        return "family plans"
        
    case .searchTags:
        return "tags"
        
    default:
        return "unspecified"
    }
}

struct Row {
    var cellType: CellType
    var position: CellPosition

    init(_ position: CellPosition, type: CellType = .text) {
        self.cellType = type
        self.position = position
    }
}

struct Section {
    var title: String
    var expanded: Bool
    var rows: [Row]
    
    init(_ rows: [Row], title: String = "", expanded: Bool = false) {
        self.rows = rows
        self.title = title
        self.expanded = expanded
    }
}
