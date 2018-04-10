//
//  MatchViewController.swift
//  Dots
//
//  Created by Sasha on 9/26/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

let prof1: [String: Any] = ["name" : "Angelina", "age": 22, "education": "University of NY", "work": "iOS Developer", "photos": ["https://images.pexels.com/photos/104827/cat-pet-animal-domestic-104827.jpeg?h=350&auto=compress&cs=tinysrgb","https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb"]]
let prof2: [String: Any] = ["name" : "Tom", "age": 22, "education": "I of NY", "work": "Model", "photos": ["https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb"]]

class MatchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var backCircleView: UIView!
}

class MatchViewController: BaseViewController {
    @IBOutlet weak var matchesCollectionView: UICollectionView!
    @IBOutlet weak var placeholderView: UIView!
    
    @IBOutlet weak var nullView: UIView!
    
    var swipeViews: [SwipeView] = []
    
    // Constraints
    var selectedPhotoIndex = 0
    
    var matches: [Profile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //profileImgView.delegate = self
        
        showTopSeparator = true
        topTitle = "MATCHES"
        
        shouldShowMenuBtn = true
        
        navigationController?.isNavigationBarHidden = false
        
        AppDelegate.shared.matchesController = self
        AppDelegate.shared.updateMatches()
        self.showLoader()
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.reload), name: NSNotification.Name(rawValue: kMessagesReceived), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.isNavigationBarHidden = self.matches.count > 0
    }
    
    // MARK:- Data reloading
    @objc func reload() {
        self.hideLoader()
        
        matches = AppDelegate.shared.newMatches
        matchesCollectionView.reloadData()
        
        for swipe in swipeViews {
            swipe.removeFromSuperview()
        }
        
        swipeViews = []
        
        navigationController?.isNavigationBarHidden = self.matches.count > 0
        var zPos = CGFloat(0.0)

        for i in 0..<matches.count {
            let swipe = SwipeView(frame: placeholderView.frame)
            swipe.delegate = self
            swipe.aboutUser.delegate = self
            swipe.aboutUser.profileImgView.matchDelegate = self
            swipe.aboutUser.profile = matches[i]
            swipe.aboutUser.updateData()
            
            zPos = zPos + 1.0
            
            swipe.layer.zPosition = zPos
            
            view.addSubview(swipe)
            view.bringSubview(toFront: swipe)
            
            if let photos = matches[i].photos {
                swipe.aboutUser.profileImgView?.sd_setImage(with: URL(string: photos[0]))
            }
            
            
            swipeViews.append(swipe)
        }
    }
    
    
    /*func pickMatch(index: Int) {
        guard index >= 0, index < matches.count else {
            return
        }
        selectedMatchIndex = index
        
        let profile = matches[selectedMatchIndex]
        profileImgView.sd_setImage(with: URL(string: profile.photos![0]))
        
        if let name = profile.name {
            if let age = profile.age {
                nameLbl.text = "\(name), \(age)"
            } else {
                nameLbl.text = "\(name)"
            }
        } else {
            if let age = profile.age {
                nameLbl.text = "\(age)"
            }
        }
        
        if let work = profile.work {
            workLbl.text = work
            
            if let education = profile.education  {
                educationLbl.text = education
            }
        } else {
            if let education = profile.education  {
                workLbl.text = education
            }
        }
        
        locationLbl.text = "2 miles away"
        
        
        if let about = profile.about {
            detailsLbl.text = about
        }
        
        selectedPhotoIndex = 0
        profileImgView.page.numberOfPages = profile.photos!.count
        matchesCollectionView.reloadData()
    }*/
}

// MARK:- ProfileImgViewDelegate methods
extension MatchViewController: MatchProfileImgViewDelegate {
    func profileImgSwipeUp(_ profileImg: ProfileImgView) {
        if matches.count > 0 {
            selectedPhotoIndex += 1
            let profile = matches[0]
            if selectedPhotoIndex > profile.photos!.count - 1 {
                selectedPhotoIndex = 0
            }
            profileImg.page.currentPage = selectedPhotoIndex
            UIView.transition(with: profileImg, duration: 0.15, options: .transitionCrossDissolve, animations: {
                profileImg.sd_setImage(with: URL(string: profile.photos![self.selectedPhotoIndex]))
            })
        }
        
    }
    
    func profileImgSwipeDown(_ profileImg: ProfileImgView) {
        if matches.count > 0 {
            selectedPhotoIndex -= 1
            let profile = matches[0]
            if selectedPhotoIndex < 0 {
                selectedPhotoIndex = profile.photos!.count - 1
            }
            profileImg.page.currentPage = selectedPhotoIndex
            UIView.transition(with: profileImg, duration: 0.15, options: .transitionCrossDissolve, animations: {
                profileImg.sd_setImage(with: URL(string: profile.photos![self.selectedPhotoIndex]))
            })
        }
    }
}


// MARK:- Collection view
extension MatchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nullView.isHidden = matches.count != 0
        view.bringSubview(toFront: nullView)
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchCollectionViewCell.typeName, for: indexPath) as! MatchCollectionViewCell
        
        let profile = matches[indexPath.row]
        cell.imgView.sd_setImage(with: URL(string: profile.photos![0]))
        
        cell.backCircleView.backgroundColor = /*indexPath.row == selectedMatchIndex ? .selectedMatchColor :*/ .notSelectedMatchColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //pickMatch(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let numberOfItems = matches.count
        
        let totalCellWidth = CGFloat(80.0) * CGFloat(numberOfItems) - 10
        if totalCellWidth < collectionView.bounds.size.width {
            
            let leftInset = (collectionView.frame.width - totalCellWidth) / 2;
            let rightInset = leftInset
            
            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        } else {
            return .zero
        }
    }
}

// MARK:- Actions
extension MatchViewController {
    
}

// MARK:- SwipeViewDelegate methods
extension MatchViewController: SwipeViewDelegate {
    func swipeViewLeft(_ card: SwipeView) {
        selectedPhotoIndex = 0
        if matches.count > 0 {
            let match = matches.first!
            self.dislike(userdId: match.userID)
            
            if swipeViews.count > 0 {
                swipeViews.removeFirst()
            }
            matches.removeFirst()
            matchesCollectionView.reloadData()
        }
    }
    
    func swipeViewRight(_ card: SwipeView) {
        selectedPhotoIndex = 0
        if matches.count > 0 {
            let match = matches.first!
            self.likePerson(userdId: match.userID)
            
            if swipeViews.count > 0 {
                swipeViews.removeFirst()
            }
            matches.removeFirst()
            matchesCollectionView.reloadData()
        }
    }
    
    func swipeViewTapped(_ card: SwipeView) {
        
    }
    
    func swipeViewUp(_ card: SwipeView) {
        /*let swipeView = swipeViews[0]
        let user = users[0]
        
        if user.selectedImageIndex == user.images!.count - 1 {
            user.selectedImageIndex = 0
        } else {
            user.selectedImageIndex += 1
        }
        users[0].selectedImageIndex = user.selectedImageIndex
        swipeView.page.currentPage = user.selectedImageIndex
        UIView.transition(with: swipeView.imgView, duration: 0.15, options: .transitionCrossDissolve, animations: {
            //swipeView.imgView.image = UIImage(named: user.images[user.selectedImageIndex].imageURL)
            swipeView.imgView.sd_setImage(with: URL(string: user.images![user.selectedImageIndex].imageURL))
        })*/
    }
    
    func swipeViewDown(_ card: SwipeView) {
        /*let swipeView = swipeViews[0]
        let user = users[0]
        
        if user.selectedImageIndex == 0 {
            user.selectedImageIndex = user.images!.count - 1
        } else {
            user.selectedImageIndex -= 1
        }
        users[0].selectedImageIndex = user.selectedImageIndex
        swipeView.page.currentPage = user.selectedImageIndex
        UIView.transition(with: swipeView.imgView, duration: 0.15, options: .transitionCrossDissolve, animations: {
            //swipeView.imgView.image = UIImage(named: )
            swipeView.imgView.sd_setImage(with: URL(string: user.images![user.selectedImageIndex].imageURL))
        })*/
    }
    
    func dislike(userdId: String) {
        self.showLoader()
        FirebaseManager.shared.dislike(userId: userdId) { (completion) in
            self.hideLoader()
        }
    }
    
    func likePerson(userdId: String) {
        self.showLoader()
        FirebaseManager.shared.addLike(userId: userdId, completion: { (completion) in
            if completion {
                let profile = ProfileManager.shared.profile
                
                //AppDelegate.shared.sendNewMatchPush(userId: self.profile.userID)
                
                if let index = profile.matches.index(of: userdId) {
                    
                    let myUsrId = ProfileManager.shared.profile.userID
                    let channelId = userdId < myUsrId ? "\(userdId)___\(myUsrId)" : "\(myUsrId)___\(userdId)"
                    
                    if index < ProfileManager.shared.profile.initialMessages.count {
                        let txt = ProfileManager.shared.profile.initialMessages[index]
                        AppDelegate.shared.post(message: Message(text: txt, userID: userdId), channel: channelId)
                    }
                    
                    //AppDelegate.shared.post(message: Message(text: text, userID: myUsrId), channel: channelId)
                    //AppDelegate.shared.postInitial(message: text, to: userdId)
                    
                    AppDelegate.shared.postConnected(userId: userdId)
                    
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
        })
    }
}
