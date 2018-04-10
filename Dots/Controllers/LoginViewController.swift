//
//  LoginViewController.swift
//  Dots
//
//  Created by Sasha on 8/1/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit
import Firebase
//import MBProgressHUD
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseDatabase
import SDWebImage
import SafariServices

class LoginViewController: BaseViewController {
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        
        let _ = Database.database().reference()
    }
}

// MARK:- Actions
extension LoginViewController {
    @IBAction func onFacebook() {
        self.showLoader()
        AuthManager.logInFacebook(self) { (user, authError) in
            if authError != nil {
                print("error")
            } else {
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, age_range, gender, first_name, last_name, email, picture.width(1024).height(1024), birthday, work, education, books, music, movies, television, favorite_teams, religion, political"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        print("success")
                        if let dict = result as? [String: Any?] {
                            if let userId = dict["id"] as? String {
                                
                                if let imageDict = dict["picture"] as? [String: Any] {
                                    if let imgUrlDict = imageDict["data"] as? [String: Any] {
                                        
                                        if let imgurl1 = imgUrlDict["url"] as? String {
                                            profileJson["photos"] = [imgurl1]
                                        }
                                    }
                                }
                                
                                if let name = dict["first_name"] as? String {
                                    profileJson["name"] = name
                                }
                                
                                if let gender = dict["gender"] as? String {
                                    profileJson["gender"] = gender
                                }
                                
                                if let birthday = dict["birthday"] as? String {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MM/dd/yyyy"
                                    let date = dateFormatter.date(from: birthday)
                                    if date != nil {
                                        profileJson["age"] = date!.age
                                    }
                                }
                                
                                if let work = dict["work"] as? [[String: Any]] {
                                    if work.count > 0 {
                                        print()
                                        
                                        var workplace = ""
                                        if let position = work[0]["position"] as? [String: Any] {
                                            if let strPos = position["name"] as? String {
                                                print(strPos)
                                                workplace = strPos
                                            }
                                        }
                                        
                                        if let employer = work[0]["employer"] as? [String: Any] {
                                            if let strEm = employer["name"] as? String {
                                                if workplace.characters.count > 0 {
                                                    workplace = "\(workplace) at \(strEm)"
                                                } else {
                                                    workplace = strEm
                                                }
                                            }
                                        }
                                        
                                        profileJson["work"] = workplace
                                    }
                                }
                                
                                if let education = dict["education"] as? [[String: Any]] {
                                    if education.count > 0 {
                                        
                                        if let school = education[education.count - 1]["school"] as? [String: Any] {
                                            if let strPos = school["name"] as? String {
                                                profileJson["education"] = strPos
                                            }
                                        }
                                    }
                                }
                                
                                
                                /*print("\(userId)/books")
                                FBSDKGraphRequest(graphPath: "\(userId)/books", parameters: nil).start(completionHandler: { (connection, result1, error) -> Void in
                                    if error == nil {
                                        if let d = result1 as? [String: Any?] {
                                            print("qq")
                                        } else {
                                            print("__")
                                        }
                                    } else {
                                        print("__")
                                    }
                                    
                                })*/
                                
                                /*if let music = dict["music"] as? [String: Any] {
                                    if let data = music["data"] as? [[String: Any]] {
                                        var res = ""
                                        for i in 0..<data.count {
                                            let d = data[i]
                                            if let value = d["name"] {
                                                if i != data.count - 1 {
                                                    res.append("\(value)\n")
                                                } else {
                                                    res.append("\(value)")
                                                }
                                            }
                                            
                                        }
                                        
                                        if res.count > 0 {
                                            profileJson["music"] = res
                                        }
                                    }
                                }*/
                                
                                if let music = dict["music"] as? [String: Any] {
                                    if let data = music["data"] as? [[String: Any]] {
                                        var res: [String] = []
                                        for d in data {
                                            if let value = d["name"] as? String {
                                                res.append(value)
                                            }
                                        }
                                        if res.count > 0 {
                                            profileJson["music"] = res
                                        }
                                    }
                                }
                                
                                if let teams = dict["favorite_teams"] as? [[String: Any]] {
                                    var res: [String] = []
                                    for team in teams {
                                        if let n = team["name"] as? String {
                                            res.append(n)
                                        }
                                    }
                                    if res.count > 0 {
                                        profileJson["sportsTeams"] = res
                                    }
                                }
                                
                                if let music = dict["books"] as? [String: Any] {
                                    if let data = music["data"] as? [[String: Any]] {
                                        var res: [String] = []
                                        for d in data {
                                            if let value = d["name"] as? String {
                                                res.append(value)
                                            }
                                        }
                                        if res.count > 0 {
                                            profileJson["books"] = res
                                        }
                                    }
                                }
                                
                                if let music = dict["television"] as? [String: Any] {
                                    if let data = music["data"] as? [[String: Any]] {
                                        var res: [String] = []
                                        for d in data {
                                            if let value = d["name"] as? String {
                                                res.append(value)
                                            }
                                        }
                                        if res.count > 0 {
                                            profileJson["tvShows"] = res
                                        }
                                    }
                                }
                                
                                if let music = dict["movies"] as? [String: Any] {
                                    if let data = music["data"] as? [[String: Any]] {
                                        var res: [String] = []
                                        for d in data {
                                            if let value = d["name"] as? String {
                                                res.append(value)
                                            }
                                        }
                                        if res.count > 0 {
                                            profileJson["movies"] = res
                                        }
                                    }
                                }
                                
                                /*if let music = dict["music.listens"] as? [String: Any] {
                                    print(music)
                                    
                                    var s: String = ""
                                    if let dataArr = music["data"] as? [[String: Any]] {
                                        for dataA in dataArr {
                                            if let ress = dataA["data"] as? [String: Any] {
                                                if let soong = ress["song"] as? [String: Any] {
                                                    if let titlle = soong["title"] as? String {
                                                        let ressss = titlle.replacingOccurrences(of: "- Listen on Deezer", with: "")
                                                        s = s + ressss
                                                    }
                                                }
                                            }
                                       }
                                    }
                                    if s.characters.count > 0 {
                                        profileJson["music"] = s
                                    }
                                }*/
                                
                                
                                if user != nil {
                                    //DispatchQueue.main.async { [weak self] in
                                    // guard nil != self else { return }
                                    
                                    FirebaseManager.shared.doesUserExists(with: { (exists, profile) in
                                        if exists {
                                            ProfileManager.shared.profile = profile!
                                            self.logIn()
                                        } else {
                                            self.creareAccount()
                                        }
                                    })
                                    
                                    /*let alert = UIAlertController(title: "Success", message: "Logged in successfully", preferredStyle: .alert)
                                     alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                                     self?.present(alert, animated: true, completion: nil)*/
                                    // }
                                } else {
                                    let alert = UIAlertController(title: "Error", message: "Failed to log in", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    } else {
                        self.hideLoader()
                        print("fail")
                    }
                })
            }
        }
    }
}

// MARK:- Private methods
private extension LoginViewController {
    func creareAccount() {
        self.hideLoader()
        NavigationCoordinator.createProfile()
    }
    
    func logIn() {
        self.hideLoader()
        AppDelegate.shared.logIn()
    }
    
    
    
    @IBAction func onTerms() {
        let svc = SFSafariViewController(url: URL(string: "http://www.dots.dating/terms")!)
        self.present(svc, animated: true, completion: nil)
    }
    
    @IBAction func onPrivacy() {
        let svc = SFSafariViewController(url: URL(string: "http://www.dots.dating/privacy")!)
        self.present(svc, animated: true, completion: nil)
    }
}
