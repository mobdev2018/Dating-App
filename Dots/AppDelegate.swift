//
//  AppDelegate.swift
//  Dots
//
//  Created by Sasha on 8/1/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import Fabric
import Crashlytics
import CoreLocation
import PubNub
import UserNotifications
import Batch
import Messages
import MessageUI
import SafariServices

/*= ["name" : "Angelina", "age": 24, "education": "University of NY", "work": "Model", "photos": ["https://images.pexels.com/photos/104827/cat-pet-animal-domestic-104827.jpeg?h=350&auto=compress&cs=tinysrgb","https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb"],"politics":"Liberal or something","music":"Shinedown","tags":["something","traveler","ololsha"]]
 */
let kRatedVer = "kRatedAppVersion"

func isLatestAppBuild() -> Bool {
    let defaults = UserDefaults.standard
    if let ratedVersion = defaults.object(forKey: kRatedVer) as? Double {
        let nsObject = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
        let versionToRate = Double(nsObject as! String)
        
        if let ver = versionToRate {
            if ver > ratedVersion {
                defaults.setValue(versionToRate!, forKey: kRatedVer)
                return false
            } else {
                return true
            }
        } else {
            return false
        }
        
    } else {
        let nsObject = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
        let versionToRate = Double(nsObject as! String)
        if versionToRate != nil {
            defaults.setValue(versionToRate!, forKey: kRatedVer)
        }
        
        
        return false
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var client: PubNub!
    
    weak var chatController: ChatViewController?
    weak var messagesController: MessagesViewController?
    weak var matchesController: MatchViewController?
    var newMatches: [Profile] = []
    var matches: [Profile] = []
    var histories: [String: [Message]] = [:]
    var matchedWith: String? = nil
    var selfDeviceToken: Data? = nil
    
    //
    static var shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let locationManager = CLLocationManager()
    var isLocationOn = true
    var profJson: [String: Any] = [:]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        Batch.start(withAPIKey: "DEV59E09C42E6E532FB7343C94E2CA") // dev
        // Batch.start(withAPIKey: "59E09C42E6B1AAE9B7744EF6FBD500") // live
        // Register for push notifications
        
        // Facebook Init
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Firebase Init
        FirebaseApp.configure()
        
        
        if !isLatestAppBuild() {
            do {
                try Auth.auth().signOut()
            } catch {
                
            }
        }
        
        return true
    }
    
    // MARK:- Facebook
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    func setUpEverything() {
        LastMessagesManager.shared.load()
        checkLocationServices()
        checkPubNub()
        checkPushNotifications()
        updateMatches()
    }
    
    func changeBadge() {
        if !LastMessagesManager.shared.hasUnread() {
            UIApplication.shared.applicationIconBadgeNumber = 0
            if let tabBarController = self.window?.rootViewController as? UITabBarController {
                if let tab = tabBarController.tabBar.items?[1] {
                    tab.badgeValue = nil
                }
            }
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 1
            if let tabBarController = self.window?.rootViewController as? UITabBarController {
                if let tab = tabBarController.tabBar.items?[1] {
                    tab.badgeValue = " "
                    tab.badgeColor = .unreadCircleColor
                }
            }
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        ProfileManager.shared.saveState()
        LastMessagesManager.shared.save()
    }
    
    // MARK :- Set up methods
    func checkLocationServices() {
        if Platform.isSimulator {
            let coordinate = CLLocationCoordinate2DMake(49.828602964413371, 24.00340617550097)
            //let coordinate = CLLocationCoordinate2DMake(40.730610, -73.935242)
            
            /*APIClient.shared.update(coordinate: coordinate, completion: { (isSuccess, message) in
             if isSuccess {
             print("Updated Location For Simulator")
             UserManager.shared.profile.long = "yes"
             }
             })*/
        } else {
            // Location
            locationManager.delegate = self;
            locationManager.distanceFilter = kCLLocationAccuracyKilometer;
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            
            // 1. status is not determined
            if CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
            } else if CLLocationManager.authorizationStatus() == .denied {
                self.isLocationOn = false
                //showAlert("Location services were previously denied. Please enable location services for this app in Settings.")
            } else if ((CLLocationManager.authorizationStatus() == .authorizedAlways) || (CLLocationManager.authorizationStatus() == .authorizedWhenInUse)) {
                locationManager.startUpdatingLocation()
            }
            
            if !isStaticLocation {
                if let location = locationManager.location {
                    let coordinate = location.coordinate
                    /*APIClient.shared.update(coordinate: coordinate, completion: { (isSuccess, message) in
                     if isSuccess {
                     UserManager.shared.profile.long = "yes"
                     print("------------")
                     print("------------")
                     print("Updated Location")
                     print("------------")
                     }
                     })*/
                }
            }
        }
    }
    
    func checkPubNub() {
        let configuration = PNConfiguration(publishKey: "pub-c-d90f11e5-ed4f-4c5a-bcba-cc98d1163cc7", subscribeKey: "sub-c-e90a03ac-a1c2-11e7-9a40-6ec8dfd6412c")
        configuration.stripMobilePayload = false
        self.client = PubNub.clientWithConfiguration(configuration)
        
        self.client.addListener(self)
    }
    
    func checkPushNotifications() {
        guard !Platform.isSimulator else {
            return
        }
        
        BatchPush.registerForRemoteNotifications()
    }
    
    
    // MARK:- Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        selfDeviceToken = deviceToken
        
        //self.client.addPushNotificationsOnChannels([ProfileManager.shared.profile.userID], withDevicePushToken: selfDeviceToken!, andCompletion: )
        
        self.client.addPushNotificationsOnChannels([ProfileManager.shared.profile.userID], withDevicePushToken: selfDeviceToken!) { (status) in
            print(status)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("")
        
        if let aps = userInfo["aps"] as? [String: Any]  {
            if let acction = aps["action"] {
                updateMatches()
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        print("Handle push from foreground")
        // custom code to handle push while app is in the foreground
        print("\(notification.request.content.userInfo)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        print("\(response.notification.request.content.userInfo)")
    }
}

// MARK:- Login
extension AppDelegate {
    func logIn() {
        NavigationCoordinator.presentMainTabBar()
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
    }
    
    func onFeedback() {
        if let tabBat = self.window?.rootViewController as? UITabBarController {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setCcRecipients(["info@dots.dating"])
                tabBat.present(mail, animated: true, completion: nil)
            }
        }
    }
    
    func onTerms() {
        if let tabBat = self.window?.rootViewController as? UITabBarController {
            let svc = SFSafariViewController(url: URL(string: "http://www.dots.dating/terms")!)
            tabBat.present(svc, animated: true, completion: nil)
        }
    }
    
    func onPrivacy() {
        if let tabBat = self.window?.rootViewController as? UITabBarController {
            let svc = SFSafariViewController(url: URL(string: "http://www.dots.dating/privacy")!)
            tabBat.present(svc, animated: true, completion: nil)
        }
    }
}

extension AppDelegate: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK:- PubNub
extension AppDelegate: PNObjectEventListener {
    func getHistory(for channelId: String) -> [Message]? {
        if client == nil {
            //chatController?.loadingIndicator.hide()
            chatController?.tableView.reloadData()
            return nil
        }
        
        if let history = histories[channelId] {
            return history
        } else {
            // download history
            
            self.client.historyForChannel(channelId, withCompletion: { (result, error) in
                if error == nil {
                    if let messages = result?.data.messages {
                        var res: [Message] = []
                        for mes in messages {
                            if let JSON = mes as? [String: Any] {
                                res.append(Message(JSON: JSON))
                            }
                        }
                        self.histories[channelId] = res.reversed()
                        
                        if self.histories[channelId]!.count > 0 {
                            let currentlast = LastMessagesManager.shared.hasMessage(for: channelId)
                            if currentlast == nil {
                                let isUsed = LastMessagesManager.shared.isUsed
                                let newLastMessage = LastMessage(channelId: channelId, text: self.histories[channelId]!.first!.text, isRead: !isUsed, userId: self.histories[channelId]!.first!.userID)
                                LastMessagesManager.shared.addNew(lastMessage: newLastMessage)
                            } else {
                                if let lastUserdI = self.histories[channelId]?.first?.userID, let lastMsg = self.histories[channelId]?.first?.text {
                                    var isRead: Bool
                                    isRead = ((lastUserdI == currentlast!.userId) && (lastMsg == currentlast!.text) && currentlast!.isRead)
                                    
                                    print(lastUserdI == currentlast!.userId)
                                    print(lastMsg == currentlast!.text)
                                    print(currentlast!.isRead)
                                    let newLastMessage = LastMessage(channelId: channelId, text: lastMsg, isRead: isRead, userId: lastUserdI)
                                    LastMessagesManager.shared.addNew(lastMessage: newLastMessage)
                                }
                            }
                        }
                        if self.chatController != nil {
                            // if self.chatController?.loadingIndicator != nil {
                            //     self.chatController?.loadingIndicator.hide()
                            // }
                        }
                    }
                }
                self.chatController?.reloadData()
            })
        }
        
        return nil
    }
    
    func post(message: Message, channel: String) {
        var payloads: [String: Any]? = nil
        
        if let userName = ProfileManager.shared.profile.name {
            payloads = ["aps" : ["alert" : "\(userName): \(message.text)", "badge": 1, "sound" : "default"]]
        } else {
            payloads = ["aps" : ["alert" : "You have received new message"]]
        }
        
        
        if client != nil {
            client.publish(message.toJSON(), toChannel: channel, mobilePushPayload: payloads) { (status) in
                print("\(status.debugDescription)")
            }
        }
    }
    
    func postConnected(userId: String) {
        var payloads: [String: Any]? = nil
        
        if let userName = ProfileManager.shared.profile.name {
            payloads = ["aps" : ["alert" : "\(userName): has connected with you!", "badge": 1, "sound" : "default"]]
        } else {
            payloads = ["aps" : ["alert" : "You have new match!"]]
        }
        
        if client != nil {
            client.publish(nil, toChannel: userId, mobilePushPayload: payloads) { (status) in
                print("\(status.debugDescription)")
            }
        }
    }
    
    func postNewMatch(userId: String) {
        var payloads: [String: Any]? = nil
        
        payloads = ["aps" : ["alert" : "You have new match request"]]
        
        if client != nil {
            client.publish("_", toChannel: userId, mobilePushPayload: payloads) { (status) in
                print("\(status.debugDescription)")
            }
        }
    }
    
    func postInitial(message: String, to userId: String) {
        var payloads: [String: Any]? = nil
        
        if let userName = ProfileManager.shared.profile.name {
            payloads = ["aps" : ["alert" : "\(userName): \(message)", "badge": 1, "sound" : "default"]]
        } else {
            payloads = ["aps" : ["alert" : "You have received new message"]]
        }
        
        
        if client != nil {
            client.publish(message, toChannel: userId, mobilePushPayload: payloads) { (status) in
                print("\(status.debugDescription)")
            }
        }
    }
    
    // Handle new message from one of channels on which client has been subscribed.
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        if let JSON = message.data.message as? [String: Any] {
            let newM = Message(JSON: JSON)
            let channelID = message.data.channel
            self.histories[channelID]?.insert(newM, at: 0)
            
            if chatController != nil {
                if chatController?.channelId == channelID {
                    if newM.userID != chatController?.userID {
                        chatController?.addMessage(newMessage: newM)
                    }
                    let lastMessage = LastMessage(channelId: channelID, text: newM.text, isRead: true, userId: newM.userID)
                    LastMessagesManager.shared.addNew(lastMessage: lastMessage)
                } else {
                    messagesController?.reload()
                    
                    let lastMessage = LastMessage(channelId: channelID, text: newM.text, isRead: false, userId: newM.userID)
                    LastMessagesManager.shared.addNew(lastMessage: lastMessage)
                }
            } else {
                let lastMessage = LastMessage(channelId: channelID, text: newM.text, isRead: false, userId: newM.userID)
                LastMessagesManager.shared.addNew(lastMessage: lastMessage)
                
                messagesController?.reload()
            }
        }
    }
    
    func updateMatches() {
        FirebaseManager.shared.getUser { (success, profile) in
            if success {
                if let prof = profile {
                    ProfileManager.shared.profile = prof
                    
                    guard prof.matches.count > 0 else { return }
                    
                    FirebaseManager.shared.downloadUsers(completion: { (users) in
                        guard let allUsers = users else {
                            return
                        }
                        
                        var channels: [String] = []
                        
                        var resUsers = allUsers
                        let usrId = prof.userID
                        
                        self.matches.removeAll()
                        self.newMatches.removeAll()
                        
                        for i in 0..<allUsers.count {

                            if !prof.matches.contains(allUsers[i].userID) {
                                if i < resUsers.count {
                                    resUsers.remove(at: i)
                                }
                            } else {
                                let matchedUser = allUsers[i]
                                let userID = matchedUser.userID
                                
                                let channelId = usrId < userID ? "\(usrId)___\(userID)" : "\(userID)___\(usrId)"
                                channels.append(channelId)
                                
                                if prof.likes.contains(userID) {
                                    self.matches.append(matchedUser)
                                } else {
                                    self.newMatches.append(matchedUser)
                                }
                                //if LastMessagesManager.shared.hasMessage(for: channelId) == nil {
                                
                                /*} else {
                                 
                                }*/
                                _ = self.getHistory(for: channelId)
                            }
                        }
                        
                        channels.append(prof.userID)
                        
                        self.messagesController?.reload()
                        self.matchesController?.reload()
                        //
                        self.client.subscribeToChannels(channels, withPresence: false)
                        
                        self.changeBadge()
                        if let deviceToken = self.selfDeviceToken {
                            self.client.addPushNotificationsOnChannels(channels, withDevicePushToken: deviceToken, andCompletion: nil)
                        }
                    })
                }
            }
        }
    }
    
    func deletePushesFor(channelId: String) {
        self.client.unsubscribeFromChannels([channelId], withPresence: false)
    }
    
    func sendNewMatchPush(userId: String) {
        let profile = ProfileManager.shared.profile
        
        if profile.matches.contains(userId) {
            var payloads = ["aps" : ["alert" : "Someone approved your chat request" , "action": "new"]] as [String : Any]
            
            if let name = ProfileManager.shared.profile.name {
                payloads = ["aps" : ["alert" : "\(name) has approved your chat request", "action": "new"]] as [String : Any]
            }
            
            client.publish("...", toChannel: userId, mobilePushPayload: payloads, storeInHistory: false, withMetadata: [:]) { (status) in
                //print("sdaf")
            }
        } else {
            var payloads = ["aps" : ["alert" : "Someone has initiated chat with you" , "action": "new"]] as [String : Any]
            
            if let name = ProfileManager.shared.profile.name {
                payloads = ["aps" : ["alert" : "\(name) has initiated chat with you", "action": "new"]] as [String : Any]
            }
            
            client.publish("...", toChannel: userId, mobilePushPayload: payloads, storeInHistory: false, withMetadata: [:]) { (status) in
                //print("sdaf")
            }
        }
        
        
    }
    
    func sendFinishedMatch(userId: String) {
        
    }
}

// MARK:- CLLocationManagerDelegate methods
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isStaticLocation {
            if let location = locations.first {
                let coordinate = location.coordinate
                
                /* APIClient.shared.update(coordinate: coordinate, completion: { (isSuccess, message) in
                 if isSuccess {
                 UserManager.shared.profile.long = "yes"
                 print("------------")
                 print("------------")
                 print("Updated Location")
                 print("------------")
                 }
                 })*/
            }
        }
    }
}
