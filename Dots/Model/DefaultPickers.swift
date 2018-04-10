//
//  DefaultArraysDict.swift
//  Dots
//
//  Created by Sasha on 8/8/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation

struct DefaultPickers {
    var genders: [String] = ["male","female"]
    
    var ages: [String] = ["18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99"]
    
    var heights: [String] = ["140", "143", "146", "148", "151", "153", "156", "158", "161", "163", "166", "168", "171", "173", "176", "179", "181", "184", "186", "189", "191", "194", "196", "199", "201", "204", "207", "209", "212", "214", "217", "219", "222", "224", "227", "229", "232", "234", "237", "240", "242", "245", "247"]
    
    var zodiacSigns: [String] = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]

    var politics: [String] = ["Liberal", "Moderate", "Conservative", "Other", "Prefer Not to Say"]
    var ethnicity: [String] = ["American Indian","Black/ African Descent", "East Asian","Hispanic / Latino","Middle Eastern","Pacific Islander","South Asian","White / Caucasian","Other","Prefer Not to Say"]
    var religious: [String] = ["Agnostic","Atheist","Buddhist","Catholic","Christian","Hindu","Jewish", "Muslim", "Spiritual", "Other","Prefer Not to Say"]
    var family: [String] = ["Don’t want kids","Want kids ","Open to kids","Have kids","Prefer not to say"]
    
    var tags: [String] = [ "nature lover", "pet friendly", "sports fanatic","haute culture", "video gamer", "gambler" ,"otaku", "foodie","early bird","night owl","musician","nerd","book worm","architect","logician","commander","debater","advocate","mediator","protagonist","campaigner","responsible","defender","executive","social butterfly","virtuoso","adventurer","entrepreneur","entertainer","mechanic","nurturer","artist","idealist","scientist","thinker","caregiver","visionary","creative","philosopher","sensitive","compassionate","ambitious","traditional","comedian","leader","traveler","obnoxious","arrogant","impatient","sarcastic","nihilist","hustler","gangster"]
    
    
    
    // search
    var searchGenders: [String] = ["Only Men","Only Women","Both"]
    
    init() {
        
    }
    
    init(json: [String : Any]) {
        if let ages = json["ages"] as? [String] {
            self.ages = ages
        }
        
        if let heights = json["heights"] as? [String] {
            self.heights = heights
        }
        
        if let genders = json["genders"] as? [String] {
            self.genders = genders
        }
        
        if let zodiacSigns = json["zodiacSigns"] as? [String] {
            self.zodiacSigns = zodiacSigns
        }
        
        if let tags = json["tags"] as? [String] {
            self.tags = tags
        }
        
        if let pol = json["politics"] as? [String] {
            self.politics = pol
        }
        
        if let pol = json["ethnicity"] as? [String] {
            self.ethnicity = pol
        }
        
        if let pol = json["religious"] as? [String] {
            self.religious = pol
        }
        
        if let pol = json["family"] as? [String] {
            self.family = pol
        }
        // Search
        
        if let searchGenders = json["searchGenders"] as? [String] {
            self.searchGenders = searchGenders
        }
    }
}
