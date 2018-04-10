//
//  SearchResultsVIewController.swift
//  Dots
//
//  Created by Sasha on 8/24/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

enum SearchResultType {
    case Profile, Ad
}

class SearchResultCell: UICollectionViewCell {
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var workLbl: UILabel!
    @IBOutlet var educationLbl: UILabel!
}

class AdSearchCell: UICollectionViewCell {
    @IBOutlet var adImgView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
}

struct SearchResult {
    var profile: Profile
    var ad: Ad
    var type: SearchResultType
    
    init(profile: Profile = Profile(JSON: [:]), ad: Ad = Ad(JSON: [:]), type: SearchResultType) {
        self.profile = profile
        self.ad = ad
        self.type = type
    }
}

func createSearchResults(from profiles: [Profile]) -> [SearchResult] {
    var results: [SearchResult] = []
    
    for profile in profiles {
        results.append(SearchResult(profile: profile, type: .Profile))
    }
    
    return results
}

class SearchResultsViewController: BaseViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nullView: UIView!
    
    var results: [SearchResult] = [] {
        didSet {
            nullView?.isHidden = !results.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTitle = "SEARCH RESULTS"
        showTopSeparator = true
        /*var temp: [SearchResult] = []
        
        var json1: [String: Any] = ["name" : "Angelina", "age": 24, "education": "University of NY", "work" : "Actress at Disney"]
        
        temp.append(SearchResult(profile: Profile(JSON: json1), type: .Profile))
        
        json1 = ["name" : "Angela", "age": 18, "education": "Some University", "work" : "Actress at Disney"]
        
        temp.append(SearchResult(profile: Profile(JSON: json1), type: .Profile))
        
        json1 = ["name" : "Lora", "age": 34, "education": "Cambridge", "work" : "Software Engineer"]
        
        temp.append(SearchResult(profile: Profile(JSON: json1), type: .Profile))
        
        // AD
        temp.append(SearchResult(ad: Ad(JSON: ["imageUrl": "https://www.google.com.ua/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwiUtpqd9czVAhVJORQKHcx_C0EQjRwIBw&url=https%3A%2F%2Fwww.pexels.com%2Fsearch%2Fcat%2F&psig=AFQjCNG-mMWx154AXDToGaLaHV71HKFnAQ&ust=1502463065797207",
                                                  "title" : "Check out this app",
                                                  "url" : "https://www.google.com"]), type: .Ad))
        
        json1 = ["name" : "Test1", "age": 20, "education": "Harwards", "work" : "QC at Facebook"]
        
        temp.append(SearchResult(profile: Profile(JSON: json1), type: .Profile))
        
        json1 = ["name" : "Test2", "age": 26, "education": "University of Test1", "work" : "Test 2 job"]
        
        temp.append(SearchResult(profile: Profile(JSON: json1), type: .Profile))
        
        results = temp*/
        
        nullView?.isHidden = !results.isEmpty
    }
}


// MARK:- Collection view methods
extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchResult = results[indexPath.row]
        
        switch searchResult.type {
        case .Profile:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.typeName, for: indexPath) as! SearchResultCell
            
            let profile = searchResult.profile
            cell.nameLbl.text = "\(profile.name!), \(profile.age!)"
            cell.workLbl.text = profile.work
            cell.educationLbl.text = profile.education
            cell.profileImgView.sd_setImage(with: URL(string: profile.photos![0]))
            return cell
        case .Ad:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdSearchCell.typeName, for: indexPath) as! AdSearchCell
            
            if let img = searchResult.ad.imageUrl {
                cell.adImgView.sd_setImage(with: URL(string: img))
            }
            
            if let title = searchResult.ad.title {
                cell.titleLbl.text = title
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width / 2.0
        return CGSize(width: width - 12.0, height: width * 1.3 - 10.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchResult = results[indexPath.row]
        
        if searchResult.type == .Profile {
            let profileVC = UIStoryboard.getController(ProfileViewController.self) as! ProfileViewController
            profileVC.isMyProfile = false
            profileVC.profile = searchResult.profile
            navigationController?.pushViewController(profileVC, animated: true)
        } else {
            if let url = searchResult.ad.url {
                if UIApplication.shared.canOpenURL(URL(string: url)!) {
                    UIApplication.shared.open(URL(string: url)!)
                }
            }
        }
        
    }
}
