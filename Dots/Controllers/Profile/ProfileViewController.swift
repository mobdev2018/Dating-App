//
//  ProfileViewController.swift
//  Dots
//
//  Created by Sasha on 9/26/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

enum MyProfileCell: Int {
    case photo, about, affiliations, interests, profiletags, music, movies, tvShows, sportsTeams, books
}


class ProfileViewController: BaseViewController {
    // UI Elements
    @IBOutlet weak var profileTableView: ProfileTableView!
    @IBOutlet weak var editBtn: UIButton!
    
    weak var profileImgView: ProfileImgView?
    var isMyProfile = true
    // Data
    var profile: Profile!
    var selectedPhotoIndex = 0
    
    var cells: [MyProfileCell] = []
    
    // Helpers
    var heightDetailsCell: DetailsCell!
    
    var musicController: TagsController! = TagsController()
    var moviesController: TagsController! = TagsController()
    var tvShowsController: TagsController! = TagsController()
    var booksController: TagsController! = TagsController()
    var sportsTeamsController: TagsController! = TagsController()
    
    var moviesHeight: CGFloat = textCellHeight
    var tvShowsHeight: CGFloat = textCellHeight
    var sportsTeamsHeight: CGFloat = textCellHeight
    var booksHeight: CGFloat = textCellHeight
    var musicHeight: CGFloat = textCellHeight
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTopSeparator = true
        
        if isMyProfile {
            profile = ProfileManager.shared.profile
            topTitle = "MY PROFILE"
            editBtn.isHidden = false
            shouldShowMenuBtn = true
        } else {
            editBtn.isHidden = false
            if let name = profile.name {
                topTitle = name
            }
            editBtn.setImage(UIImage(named: "chat-initiate"), for: .normal)
        }
        
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func reloadData() {
        cells = []
        cells.append(.photo)
        
        if !profile.getAbout().isEmpty  {
            cells.append(.about)
        }
        
        if !profile.getAffiliations().isEmpty {
            cells.append(.affiliations)
        }
        /*if !profile.getInterests().isEmpty {
            cells.append(.interests)
        }*/
        
        if let _ = profile.tags {
            cells.append(.profiletags)
        }
        
        if let music = profile.music {
            musicController.selectedTags = music
            if music.count > 0 {
                cells.append(.music)
            }
        }
        
        if let movies = profile.movies {
            moviesController.selectedTags = movies
            if movies.count > 0 {
                cells.append(.movies)
            }
        }
        
        if let tvShows = profile.tvShows {
            tvShowsController.selectedTags = tvShows
            if tvShows.count > 0 {
                cells.append(.tvShows)
            }
        }
        
        if let sportsTeams = profile.sportsTeams {
            sportsTeamsController.selectedTags = sportsTeams
            if sportsTeams.count > 0 {
                cells.append(.sportsTeams)
            }
        }
        
        if let books = profile.books {
            booksController.selectedTags = books
            if books.count > 0 {
                cells.append(.books)
            }
        }
        
        
        profileTableView.reloadData()
    }
    
    func didPressSend(message: String) {
        dismiss(animated: true, completion: nil)
        likePerson(with: message)
    }
    
    func didPressCancel() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- Table view methods
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = cells[indexPath.row]
        
        if cellData == .photo {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoProfileCell.typeName) as! PhotoProfileCell
            cell.profileImgView.page.numberOfPages = 5
            profileImgView = cell.profileImgView
            cell.profileImgView.delegate = self
            
            if selectedPhotoIndex < profile.photos!.count {
                print("")
            } else {
                selectedPhotoIndex = 0
                profileImgView?.page.currentPage = selectedPhotoIndex
            }
            
            cell.profileImgView.sd_setImage(with: URL(string: profile.photos![selectedPhotoIndex]))
            cell.profileImgView.page.numberOfPages = profile.photos!.count
            
            cell.profileImgView.page.isHidden = cell.profileImgView.page.numberOfPages == 1
            
            cell.nameLbl.text = "\(profile.name!), \(profile.age!)"
            if let work = profile.work {
                
                cell.workLbl.text = work
                if let education = profile.education {
                    cell.educationLbl.text = education
                }
                
            } else {
                if let education = profile.education {
                    cell.workLbl.text = education
                }
            }
            return cell
        }

        if cellData == .music {
            let cell = tableView.dequeueReusableCell(withIdentifier: TagsCell.typeName, for: indexPath) as! TagsCell
            cell.isEmpty = false
            cell.nameLbl.isHidden = false
            cell.collectionView.delegate = self.musicController
            cell.collectionView.dataSource = self.musicController
            
            cell.collectionView.reloadData()
            let tagsH = CGFloat(14.0)
            
            cell.nameLbl.setProfileName("MUSIC")
            if self.musicHeight != cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH {
                self.musicHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH
            }
            return cell
        }
        
        if cellData == .movies {
            let cell = tableView.dequeueReusableCell(withIdentifier: TagsCell.typeName, for: indexPath) as! TagsCell
            cell.isEmpty = false
            cell.nameLbl.isHidden = false
            cell.collectionView.delegate = self.moviesController
            cell.collectionView.dataSource = self.moviesController
            
            cell.collectionView.reloadData()
            let tagsH = CGFloat(14.0)
            
            cell.nameLbl.setProfileName("MOVIES")
            if self.moviesHeight != cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH {
                self.moviesHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH
            }
            return cell
        }
        
        if cellData == .tvShows {
            let cell = tableView.dequeueReusableCell(withIdentifier: TagsCell.typeName, for: indexPath) as! TagsCell
            cell.isEmpty = false
            cell.nameLbl.isHidden = false
            cell.collectionView.delegate = self.tvShowsController
            cell.collectionView.dataSource = self.tvShowsController
            
            cell.collectionView.reloadData()
            let tagsH = CGFloat(14.0)
            
            cell.nameLbl.setProfileName("TV SHOWS")
            if self.tvShowsHeight != cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH {
                self.tvShowsHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH
            }
            return cell
        }
        
        if cellData == .sportsTeams {
            let cell = tableView.dequeueReusableCell(withIdentifier: TagsCell.typeName, for: indexPath) as! TagsCell
            cell.isEmpty = false
            cell.nameLbl.isHidden = false
            cell.collectionView.delegate = self.sportsTeamsController
            cell.collectionView.dataSource = self.sportsTeamsController
            
            cell.collectionView.reloadData()
            let tagsH = CGFloat(14.0)
            
            cell.nameLbl.setProfileName("SPORTS TEAMS")
            if self.sportsTeamsHeight != cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH {
                self.sportsTeamsHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH
            }
            return cell
        }
        
        if cellData == .books {
            let cell = tableView.dequeueReusableCell(withIdentifier: TagsCell.typeName, for: indexPath) as! TagsCell
            cell.isEmpty = false
            cell.nameLbl.isHidden = false
            cell.collectionView.delegate = self.booksController
            cell.collectionView.dataSource = self.booksController
            
            cell.collectionView.reloadData()
            let tagsH = CGFloat(14.0)
            
            cell.nameLbl.setProfileName("BOOKS")
            if self.booksHeight != cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH {
                self.booksHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.typeName) as! DetailsCell
        
        var subsections: [(String,String)] = []
        
        if cellData == .about {
            subsections = profile.getAbout()
            cell.setName("ABOUT")
        }else if cellData == .affiliations {
            subsections =  profile.getAffiliations()
            cell.setName("AFFILIATIONS")
        } /*else if cellData == .interests {
            cell.setName("INTERESTS")
            subsections = profile.getInterests()
        } */else if cellData == .profiletags {
            cell.setName("TAGS")
            subsections = profile.getTagsList()
        }

        cell.detailsView.setLabels(textsDict: subsections)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let cellData = cells[indexPath.row]
        
        if cellData == .photo {
            return self.view.bounds.size.width * 1.32
        }
        
        if cellData == .books {
            return booksHeight
        }
        
        if cellData == .movies {
            return moviesHeight
        }
        
        if cellData == .music {
            return musicHeight
        }
        
        if cellData == .tvShows {
            return tvShowsHeight
        }
        
        if cellData == .sportsTeams {
            return sportsTeamsHeight
        }
        
        if heightDetailsCell == nil {
            heightDetailsCell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.typeName) as! DetailsCell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.typeName) as! DetailsCell
        var subsections: [(String,String)] = []
        if cellData == .about {
            subsections = profile.getAbout()
        }else if cellData == .affiliations {
            subsections =  profile.getAffiliations()
        } /*else if cellData == .interests {
            subsections = profile.getInterests()
        }*/ else if cellData == .profiletags {
            subsections = profile.getTagsList()
        }
        
        cell.detailsView.width = self.view.bounds.size.width - 55.0
        cell.detailsView.setLabels(textsDict: subsections)
        
        
        return cell.detailsView.totalHeight + 15.0
    }
    
   /* func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
        cell.updateConstraints()
    }*/
}

// MARK:- ProfileImgViewDelegate methods
extension ProfileViewController: ProfileImgViewDelegate {
    func profileImgSwipeUp() {
        selectedPhotoIndex += 1
        if selectedPhotoIndex > profile.photos!.count - 1 {
            selectedPhotoIndex = 0
        }
        profileImgView?.page.currentPage = selectedPhotoIndex
        UIView.transition(with: profileImgView!, duration: 0.15, options: .transitionCrossDissolve, animations: {
            self.profileImgView?.sd_setImage(with: URL(string: self.profile.photos![self.selectedPhotoIndex]))
        })
    }
    
    func profileImgSwipeDown() {
        selectedPhotoIndex -= 1
        if selectedPhotoIndex < 0{
            selectedPhotoIndex = profile.photos!.count - 1
        }
        profileImgView?.page.currentPage = selectedPhotoIndex
        UIView.transition(with: profileImgView!, duration: 0.15, options: .transitionCrossDissolve, animations: {
            self.profileImgView?.sd_setImage(with: URL(string: self.profile.photos![self.selectedPhotoIndex]))
        })
    }
}

// MARK:- Actions
extension ProfileViewController {
    @IBAction func onEdit() {
        if isMyProfile {
            let s = UIStoryboard.getController(SetUpProfileViewController.self) as! SetUpProfileViewController
            s.isEditProfile = true
            navigationController?.pushViewController(s, animated: true)
        } else {
            if !ProfileManager.shared.profile.likes.contains(profile.userID) {
                showNewMessage()
                
                
                /*let alertController = UIAlertController(title: "Email?", message: "Please input your email:", preferredStyle: .Alert)
                
                let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                    if let field = alertController.textFields![0] as? UITextField {
                        // store your data
                        NSUserDefaults.standardUserDefaults().setObject(field.text, forKey: "userEmail")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    } else {
                        // user did not fill field
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
                
                alertController.addTextFieldWithConfigurationHandler { (textField) in
                    textField.placeholder = "Your message"
                }
                
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)*/
                
                /*self.showLoader()
                FirebaseManager.shared.addLike(userId: profile.userID, completion: { (completion) in
                    if completion {
                        let profile = ProfileManager.shared.profile
                        
                        AppDelegate.shared.sendNewMatchPush(userId: self.profile.userID)
                        
                        if profile.matches.contains(self.profile.userID) {
                            let alert = UIAlertController(title: "Great", message: "You can now chat with this person in Messages tab", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                                AppDelegate.shared.updateMatches()
                                if let tabBarController = self.tabBarController {
                                    tabBarController.selectedIndex = 1
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Success", message: "You have initiated a chat. User will receive notification.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                                AppDelegate.shared.updateMatches()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    self.hideLoader()
                })*/
            } else {
                let alert = UIAlertController(title: "Oops", message: "You have already initiated chat with this person. Please wait for reply.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                present(alert, animated: true, completion: nil )
            }
            
        }
    }
    
    func showNewMessage() {
        let firstMessage = UIStoryboard.getController(FirstMessageViewController.self) as! FirstMessageViewController
        
        firstMessage.delegate = self
        firstMessage.modalPresentationStyle = .overCurrentContext
        firstMessage.modalTransitionStyle = .crossDissolve
        
        DispatchQueue.main.async {
            if let tabBarController = self.tabBarController {
                tabBarController.present(firstMessage, animated: true, completion: nil)
            } else {
                self.present(firstMessage, animated: true, completion: nil)
            }
        }
        /*
        let alert = UIAlertController(title: "New Chat", message: "Please enter your message to this person", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .cancel) { (_) in
            if let field = alert.textFields?[0], let text = field.text, text.characters.count > 0 {
                self.likePerson(with: text)
            } else {
                // user did not fill field
                
                let alert = UIAlertController(title: "Oops", message: "You did not enter any message. Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in }
        alert.addTextField { (textField) in
            textField.placeholder = "Your message"
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)*/
    }
    
    func likePerson(with text: String) {
        self.showLoader()
        FirebaseManager.shared.addLike(userId: profile.userID, text: text, completion: { (completion) in
            if completion {
                let profile = ProfileManager.shared.profile
                
                //AppDelegate.shared.sendNewMatchPush(userId: self.profile.userID)
                
                if let index = profile.matches.index(of: self.profile.userID) {
                    
                    let myUsrId = ProfileManager.shared.profile.userID
                    let channelId = self.profile.userID < myUsrId ? "\(self.profile.userID)___\(myUsrId)" : "\(myUsrId)___\(self.profile.userID)"
                    
                    if index < ProfileManager.shared.profile.initialMessages.count {
                        let txt = ProfileManager.shared.profile.initialMessages[index]
                        AppDelegate.shared.post(message: Message(text: txt, userID: self.profile.userID), channel: channelId)
                    }
                    
                    AppDelegate.shared.post(message: Message(text: text, userID: myUsrId), channel: channelId)
                    AppDelegate.shared.postInitial(message: text, to: self.profile.userID)
                    
                    let alert = UIAlertController(title: "Great", message: "You can now chat with this person in Messages tab", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                        AppDelegate.shared.updateMatches()
                        if let tabBarController = self.tabBarController {
                            tabBarController.selectedIndex = 1
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Success", message: "You have initiated a chat. User will receive notification.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                        AppDelegate.shared.updateMatches()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    AppDelegate.shared.postNewMatch(userId: profile.userID)
                }
            }
            self.hideLoader()
        })
    }
}
