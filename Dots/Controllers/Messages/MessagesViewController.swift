//
//  MessagesViewController.swift
//  Dots
//
//  Created by Sasha on 9/27/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class MessagesViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nullView: UIView!
    
    var matches: [Profile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTopSeparator = true
        shouldShowMenuBtn = true
        topTitle = "MESSAGES"
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.reload), name: NSNotification.Name(rawValue: kMessagesReceived), object: nil)
        
        AppDelegate.shared.messagesController = self
        reload()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Data reloading
    @objc func reload() {
        matches = AppDelegate.shared.matches
        tableView.reloadData()
    }
}

// MARK:- Table view methods
extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nullView.isHidden = matches.count != 0
        view.bringSubview(toFront: nullView)
        return matches.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchMessageTableViewCell.typeName) as! MatchMessageTableViewCell
        let match = matches[indexPath.row]
        let usrId = ProfileManager.shared.profile.userID
        let channelId = usrId < match.userID ? "\(usrId)___\(match.userID)" : "\(match.userID)___\(usrId)"
        
        if let urlString = match.photos?[0] {
            cell.profileImgView.sd_setImage(with: URL(string: urlString))
        }
        
        if let name = match.name {
            cell.nameLbl.text = name
        }
        
        var isRead = true
        var lastM = ""
        if let lstMessage =  LastMessagesManager.shared.hasMessage(for: channelId) {
            isRead = lstMessage.isRead
            lastM = lstMessage.text
        }
        
        cell.messageLbl.text = lastM
        
        if isRead {
            cell.nameLbl.textColor = .defaultNameColor
            cell.messageLbl.textColor = .defaultMessageColor
            cell.unreadImgWidthConstraint.constant = 0.0
            cell.unreadImgView.isHidden = true
            cell.circleBackView.backgroundColor = .defaultCircleColor
        } else {
            cell.circleBackView.backgroundColor = .unreadCircleColor
            cell.nameLbl.textColor = .unreadNameColor
            cell.messageLbl.textColor = .unreadMessageColor
            cell.unreadImgWidthConstraint.constant = self.view.frame.size.width / 7.0
            cell.unreadImgView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let match = matches[indexPath.row]
            deleteMessagesFor(match: match, index: indexPath.row)
        } else {
            return
        }
    }
    
    func deleteMessagesFor(match: Profile, index: Int) {
        let actionController = UIAlertController(title: nil, message: "Are you sure you want to permanently delete this conversation?", preferredStyle: .actionSheet)
        
        let blockAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            
            let usrId = ProfileManager.shared.profile.userID
            let channelId = usrId < match.userID ? "\(usrId)___\(match.userID)" : "\(match.userID)___\(usrId)"
            self.showLoader()
            
            FirebaseManager.shared.dislike(userId: match.userID, completion: { (completed) in
                if completed {
                    AppDelegate.shared.deletePushesFor(channelId: channelId)
                    self.matches.remove(at: index)
                    self.tableView.reloadData()
                }
                self.hideLoader()
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("Cancel")
        }
        
        actionController.addAction(blockAction)
        actionController.addAction(cancelAction)
        
        present(actionController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profile = matches[indexPath.row]
        let chatVC = UIStoryboard.getController(ChatViewController.self) as! ChatViewController
        chatVC.user = profile
        
        let usrId = ProfileManager.shared.profile.userID
        chatVC.userID = usrId
        
        if let name = profile.name {
            chatVC.responderUserName = name
        }
        
        if let imgURL = profile.photos?[0] {
            chatVC.responderImageURL = imgURL
        }
        
        let matchUsrId = profile.userID
        chatVC.channelId = usrId < matchUsrId ? "\(usrId)___\(matchUsrId)" : "\(matchUsrId)___\(usrId)"
        
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

// MARK:- Actions
extension MessagesViewController {
    @IBAction func onSearchBtn() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
        }
    }
}
