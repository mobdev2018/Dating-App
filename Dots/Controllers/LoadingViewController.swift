//
//  LoadingViewController.swift
//  Dots
//
//  Created by Sasha on 8/3/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit
import Firebase


//TODO: Delete this
///

let names = ["Lilla", "Hermina",
             "Holli","Alejandrina","Hermelinda",
             "Lawana",
             "Roslyn",
             "Chassidy",
             "Juanita",
             "Linette",
             "Verline",
             "Alycia",
             "Annika",
             "Valeri",
             "Leena",
             "Bao",
             "Maryland",
             "Kimber",
             "Tam",
             "Lyndsay",
             "Zula",
             "Casie",
             "Roseline",
             "Felicita",
             "Elfrieda",
             "Brandee",
             "Belia",
             "Anitra",
             "Charmain",
             "Alma",
             "Emiko",
             "Janelle",
             "Lakeisha",
             "Ivey",
             "Kyra",
             "Carmelita",
             "Nicole",
             "Meridith",
             "Georgianne",
             "Machelle",
             "Deja",
             "Genna",
             "Darlene",
             "Natisha",
             "Audrea",
             "Juliane",
             "Romana",
             "Reva",
             "Tomasa",
             "Dionne"]

let educations = ["NY Univercity", "Paris Univercity", "Kiyv Univercity", "Madrid High School", "Tokyo Univercity"]

let workplaces =  ["Personal Care Aide",
                   "Computer Programmer",
                   "Recreational Therapist",
                   "Medical Assistant",
                   "Designer",
                   "Electrician",
                   "Writer",
                   "Landscape Architect",
                   "Systems Analyst",
                   "Massage Therapist",
                   "Court Reporter",
                   "Painter",
                   "Historian",
                   "Human Resources",
                   "HR Specialist",
                   "Physicist",
                   "School Teacher",
                   "Therapist",
                   "Counselor",
                   "Coach",
                   "Plumber",
                   "Artist",
                   "Chef",
                   "Editor",
                   "Tech Specialist",
                   "Accountant",
                   "Anthropologist",
                   "Elementary School Teacher",
                   "Urban Planner",
                   "Photographer",
                   "Cost Estimator",
                   "Interpreter",
                   "School Psychologist",
                   "Art Director",
                   "Systems Analyst",
                   "Physician",
                   "Epidemiologist",
                   "School Counselor",
                   "Logistician",
                   "Manager",
                   "Landscaper",
                   "Physical Therapist",
                   "Professional athlete",
                   "Paramedic",
                   "Hairdresser",
                   "Reporter",
                   "Food Scientist",
                   "Educator",
                   "Sports Coach"]

func randomElement(array: [String]) -> String {
    let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
    return array[randomIndex]
}

///
class LoadingViewController: BaseViewController {
    
    private var handle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoader()
        
        if FirebaseManager.shared.isConnected {
            self.load()
        } else {
            let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.load()
            }
        }
    }
     
    func load() {
        self.showLoader()
        self.handle =  Auth.auth().addStateDidChangeListener({ (auth, user) in
            self.generateFakeUsers()
            
            if user != nil {
                FirebaseManager.shared.doesUserExists(with: { (exists, profile) in
                    if exists {
                        if let p = profile {
                            ProfileManager.shared.profile = p
                            
                            if let uID = Auth.auth().currentUser?.uid {
                                ProfileManager.shared.profile.userID = uID
                            }
                        }
                        NavigationCoordinator.presentMainTabBar()
                    } else {
                        NavigationCoordinator.presentWelcomeScreen()
                    }
                })
            } else {
                NavigationCoordinator.presentWelcomeScreen()
            }
        })
    }
    
    func generateFakeUsers() {
        //man - //https://images.pexels.com/photos/572463/pexels-photo-572463.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb
        //woman //https://images.pexels.com/photos/323503/pexels-photo-323503.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb
        //https://images.pexels.com/photos/413850/pexels-photo-413850.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb
        //https://images.pexels.com/photos/318380/pexels-photo-318380.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb
        for i in 0..<50 {
            var profile = Profile(JSON: [:])
            
            profile.name = randomElement(array: names)
            profile.age =  18 + Int(arc4random_uniform(30))
            profile.height = 140 + Int(arc4random_uniform(90))
            profile.work = "\(randomElement(array: workplaces))"
            profile.education = "\(randomElement(array: educations))"
            profile.gender = "female"
            profile.about = "A few lines about me"
            profile.interestedIn = [0,1,2,3,4,5,6]
            profile.photos = ["https://images.pexels.com/photos/323503/pexels-photo-323503.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb",
            "ttps://images.pexels.com/photos/413850/pexels-photo-413850.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb",
            "https://images.pexels.com/photos/318380/pexels-photo-318380.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb"]
            let defaultPickers = DefaultPickers()
            
            let randTagsCount = 1 + Int(arc4random_uniform(5))
            profile.tags = []
            for _ in 0..<randTagsCount {
                let s = randomElement(array: defaultPickers.tags)
                if !(profile.tags?.contains(s))! {
                    profile.tags?.append(s)
                }
            }
            
            profile.religioulsBeliefs = randomElement(array: defaultPickers.religious)
            profile.zodiacSign = randomElement(array: defaultPickers.zodiacSigns)
            profile.politics = randomElement(array: defaultPickers.politics)
            profile.ethnicity = randomElement(array: defaultPickers.ethnicity)
            profile.familyPlans = randomElement(array: defaultPickers.family)
            
           // FirebaseManager.shared.uploadFakeUser(id: "\(i)", profile: profile)
        }
        
        /*guard let uid = Auth.auth().currentUser?.uid else { return }
        //let key = self.databaseRef.child(FirebaseKeys.users).child(uid).key
        let recipeObj = profile.toJSON()
        self.databaseRef.child(FirebaseKeys.users).child(uid).setValue(recipeObj)*/
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(self.handle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
