//
//  SetUpInterestedInViewController.swift
//  Dots
//
//  Created by Sasha on 9/29/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

let setUpInterested = UIColor(hex: "BD86A2")
let setUpInterestedDefaultText = UIColor(hex: "4F4D4D")
let setUpInterestedDefaultBackgrounds = UIColor(hex: "EDEEEF")

class SetUpInterestedInViewController: BaseViewController {
    @IBOutlet weak var CasualMen: UIButton!
    @IBOutlet weak var CasualWomen: UIButton!
    @IBOutlet weak var CasualBoth: UIButton!
    
    @IBOutlet weak var SeriousMen: UIButton!
    @IBOutlet weak var SeriousWomen: UIButton!
    @IBOutlet weak var SeriousBoth: UIButton!
    
    @IBOutlet weak var NewFriends: UIButton!
    
    @IBOutlet weak var Roommates: UIButton!
    @IBOutlet weak var BusinessPartners: UIButton!
    
    
    @IBOutlet var nextBtn: UIButton!
    
    weak var delegate: SetUpProfileViewController?
    weak var searchDelegate: SearchViewController?
    
    var selectedState: [Int] = []
    var isEditProfile = false
    var isSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditProfile {
            nextBtn.setTitle("Save", for: .normal)
            setAllDefault()
        }
        
        showTopSeparator = true
        topTitle = "INTERESTED IN"
        
        AppDelegate.shared.checkLocationServices()
    }
}

// MARK:- Actions
extension SetUpInterestedInViewController {
    @IBAction func onCasualMen() {
        change(number:0)
        setAllDefault()
    }
    
    @IBAction func onCasualWomen() {
        change(number: 1)
        setAllDefault()
    }
    
    @IBAction func onCasualBoth() {
        change(number: 2)
        setAllDefault()
    }
    
    //
    @IBAction func onSeriousMen() {
        change(number: 3)
        setAllDefault()
    }
    
    @IBAction func onSeriousWomen() {
        change(number: 4)
        setAllDefault()
    }
    
    @IBAction func onSeriousBoth() {
        change(number: 5)
        setAllDefault()
    }
    
    //
    @IBAction func onNewFriends() {
        change(number: 6)
        setAllDefault()
    }
    
    @IBAction func onRoommates() {
        change(number: 7)
        setAllDefault()
    }
    
    @IBAction func onBusinessPartners() {
        change(number: 8)
        setAllDefault()
    }
    
    func change(number: Int) {
        if isSearch {
            selectedState = [number]
        } else {
            if let index = selectedState.index(of: number) {
                selectedState.remove(at: index)
            } else {
                selectedState.append(number)
            }
        }
        
    }
    
    func setAllDefault() {
        if !selectedState.contains(0) {
            CasualMen.tintColor = setUpInterestedDefaultText
            CasualMen.backgroundColor = setUpInterestedDefaultBackgrounds
        } else {
            CasualMen.tintColor = .white
            CasualMen.backgroundColor = setUpInterested
        }
        
        
        if !selectedState.contains(1) {
            CasualWomen.tintColor = setUpInterestedDefaultText
            CasualWomen.backgroundColor = setUpInterestedDefaultBackgrounds
        } else {
            CasualWomen.tintColor = .white
            CasualWomen.backgroundColor = setUpInterested
        }
        
        if !selectedState.contains(2) {
            CasualBoth.tintColor = setUpInterestedDefaultText
            CasualBoth.backgroundColor = setUpInterestedDefaultBackgrounds
        } else {
            CasualBoth.tintColor = .white
            CasualBoth.backgroundColor = setUpInterested
        }
        
        if !selectedState.contains(3) {
            SeriousMen.tintColor = setUpInterestedDefaultText
            SeriousMen.backgroundColor = setUpInterestedDefaultBackgrounds
        } else {
            SeriousMen.tintColor = .white
            SeriousMen.backgroundColor = setUpInterested
        }
        
        if !selectedState.contains(4) {
            SeriousWomen.tintColor = setUpInterestedDefaultText
            SeriousWomen.backgroundColor = setUpInterestedDefaultBackgrounds
        } else {
            SeriousWomen.tintColor = .white
            SeriousWomen.backgroundColor = setUpInterested
        }
        
        if !selectedState.contains(5) {
            SeriousBoth.tintColor = setUpInterestedDefaultText
            SeriousBoth.backgroundColor = setUpInterestedDefaultBackgrounds
        } else {
            SeriousBoth.tintColor = .white
            SeriousBoth.backgroundColor = setUpInterested
        }
        
        if !selectedState.contains(6) {
            NewFriends.tintColor = setUpInterestedDefaultText
            NewFriends.backgroundColor = setUpInterestedDefaultBackgrounds
        } else {
            NewFriends.tintColor = .white
            NewFriends.backgroundColor = setUpInterested
        }
        
        if !selectedState.contains(7) {
            Roommates.tintColor = setUpInterestedDefaultText
            Roommates.backgroundColor = setUpInterestedDefaultBackgrounds
        } else {
            Roommates.tintColor = .white
            Roommates.backgroundColor = setUpInterested
        }
        
        if !selectedState.contains(8) {
            BusinessPartners.tintColor = setUpInterestedDefaultText
            BusinessPartners.backgroundColor = setUpInterestedDefaultBackgrounds
        } else {
            BusinessPartners.tintColor = .white
            BusinessPartners.backgroundColor = setUpInterested
        }
    }
    
    @IBAction func onNext() {
        
        if selectedState.count > 0 {
            if isEditProfile {
                delegate?.profile.interestedIn = selectedState
                searchDelegate?.filter.interestedIn = selectedState
                navigationController?.popViewController(animated: true)
            } else {
                profileJson["interestedIn"] = selectedState
                performSegue(withIdentifier: "SetUpTags", sender: nil)
            }
        } else {
            let alert = UIAlertController(title: "Oops", message: "Please select what your search results should be interested in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        
    }
}
