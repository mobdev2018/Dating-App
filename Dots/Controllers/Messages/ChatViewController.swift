//
//  ChatViewController.swift
//  Dots
//
//  Created by Sasha on 9/27/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class ChatViewController: KeyboardViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var sendBox: SendBoxView!
    @IBOutlet var topProfileView: UIView!
    @IBOutlet var topImageView: UIImageView!
    
    var cellForHeight: LeftChatCell?
    var tempMessages: [Message] = []
    var cashedSizes: [CGFloat] = []
    
    // data
    
    var userID: String! = "222"
    var responderUserName: String! = ""
    var responderImageURL: String! = ""
    var channelId: String! = ""
    var user: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTopSeparator = true
        
        topTitle = responderUserName
        topImageView.sd_setImage(with: URL(string: responderImageURL))
        if let titleV = navigationItem.titleView {
            titleV.addSubview(topProfileView)
            
            let xPos = topProfileView.rightAnchor.constraint(equalTo: titleV.leftAnchor, constant: -10.0)
            let yPos = topProfileView.centerYAnchor.constraint(equalTo: titleV.centerYAnchor)
            NSLayoutConstraint.activate([xPos,yPos])
            
            //topProfileView.center = CGPoint(x: titleV.bounds.size.width / 2.0 - topProfileView.bounds.size.width - 10, y: titleV.bounds.size.height / 2.0)
        }
        
        tableView.transform = tableView.transform.rotated(by: -(CGFloat(Float.pi)))
        let sizes = [CGFloat](repeating: CGFloat(0), count: 4)
        cashedSizes.append(contentsOf: sizes)
        
        AppDelegate.shared.chatController = self
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if let lastM = LastMessagesManager.shared.hasMessage(for: channelId) {
            lastM.isRead = true
            LastMessagesManager.shared.addNew(lastMessage: lastM)
        }
        
        AppDelegate.shared.changeBadge()
        
        tempMessages = []
        reloadData()
        sendBox.updateState()
        sendBox.delegate = self
    }
    
    func reloadData() {
        self.showLoader()
        if let t = AppDelegate.shared.getHistory(for: channelId) {
            
            if tempMessages.count > 0 {
                if t.first?.text == tempMessages.first?.text {
                    if t.first?.userID == tempMessages.first?.userID {
                        return
                    }
                }
            }
            
            tempMessages.removeAll()
            cashedSizes.removeAll()
            tempMessages.append(contentsOf: t)
            let sizes = [CGFloat](repeating: CGFloat(0), count: t.count)
            cashedSizes.append(contentsOf: sizes)
            
            tableView.reloadData()
            self.hideLoader()
        }
        
    }
    
    func addMessage(newMessage: Message) {
        tempMessages.insert(newMessage, at: 0)
        cashedSizes.insert(0, at: 0)
        
        tableView.reloadData()
        tableView.setContentOffset(.zero, animated: true)
    }
    
    deinit {
        print("deinit ChatViewController")
    }
}

// MARK:- TableView methods
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftChatCell.typeName) as! LeftChatCell
        
        let userMessage = tempMessages[indexPath.row]
        cell.messagelbl.text = userMessage.text
        
        if !cell.isRotated {
            cell.transform = cell.transform.rotated(by: CGFloat(Float.pi))
            cell.isRotated = true
        }
        
        if userMessage.isMe(id: userID) {
            cell.leftConstraint.isActive = false
            cell.rightConstraint.isActive = true
            cell.messagelbl.textAlignment = .right
            cell.messagelbl.textColor = .white
            cell.messageBubbleView.backgroundColor = .myMessageBackgroundColor
            cell.profileBackView.isHidden = true
        } else {
            cell.rightConstraint.isActive = false
            cell.leftConstraint.isActive = true
            cell.messagelbl.textAlignment = .left
            cell.messagelbl.textColor = .black
            cell.messageBubbleView.backgroundColor = .matchMessageBackgroundColor
            cell.profileBackView.isHidden = false
        }
        
        cell.profileImgView.sd_setImage(with: URL(string: responderImageURL))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (cellForHeight == nil) {
            cellForHeight = tableView.dequeueReusableCell(withIdentifier: LeftChatCell.typeName) as? LeftChatCell
            cellForHeight?.messagelbl.preferredMaxLayoutWidth = 290
        }
        if indexPath.row < tempMessages.count {
            cellForHeight?.messagelbl.text = tempMessages[indexPath.row].text
        }
        let height = cellForHeight?.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        if indexPath.row < tempMessages.count {
            cashedSizes[indexPath.row] = height!
        }
        
        return height!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if cashedSizes[indexPath.row] == 0 {
            return 64
        }
        return cashedSizes[indexPath.row]
    }
}

// MARK:- Actions
extension ChatViewController {
    @IBAction func onReport() {
        let actionController = UIAlertController(title: nil, message: "You won't be able to chat with this user anymore in the future", preferredStyle: .actionSheet)
        
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { (_) in
            print("Block")
        }
        
        let reportAction = UIAlertAction(title: "Report", style: .default) { (_) in
            print("Report")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("Cancel")
        }
        
        actionController.addAction(blockAction)
        actionController.addAction(reportAction)
        actionController.addAction(cancelAction)
        
        present(actionController, animated: true, completion: nil)
    }
}

// MARK:- SendBoxView Delegate
extension ChatViewController: SendBoxViewDelegate{
    func didSendText(text: String) {
        let m1 = Message(text: text, userID: userID)
        addMessage(newMessage: m1)
        
        AppDelegate.shared.post(message: m1, channel: channelId)
    }
}
