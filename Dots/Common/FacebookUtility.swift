//
//  FacebookUtility.swift
//  Dots
//
//  Created by Sasha on 8/1/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

let fbPermitions = ["public_profile", "email",  "user_birthday", "user_education_history", "user_actions.music", "user_actions.video", "user_friends", "user_religion_politics", "user_work_history", "user_about_me", "user_likes"]

enum FbResponse {
    case success
    case fail
    case permissionNotGranted
    case canceled
}

enum Permissions {
    case write
    case read
    
    var requiredPermissions: Set<String> {
        return Set(fbPermitions)
    }
    
    func isRequiredPermissionsGranted() -> Bool {
        var granted = true
        requiredPermissions.forEach {
            if (!FacebookUtility.currentToken().hasGranted($0)) {
                granted = false
            }
        }
        return granted
    }
}

struct FacebookUtility {
    
    // MARK: - Private
    
    /// single manager for facebook auth
    private static var loginManager: FBSDKLoginManager = {
        return FBSDKLoginManager()
    }()
    
    /// check facebook token
    private static func isLoggedFacebook() -> Bool {
        return (FBSDKAccessToken.current() != nil)
    }
    
    /// check on all required facebook read permissions
    /// list of permission should be provided on Permissions enum
    private static func isReadPermissionsGranted()  -> Bool {
        return Permissions.read.isRequiredPermissionsGranted()
    }
    
    /// check on all required facebook write permissions
    /// list of permission should be provided on Permissions enum
    private static func isWritePermissionsGranted()  -> Bool {
        return Permissions.write.isRequiredPermissionsGranted()
    }
    
    // check on permissions error
    private static func isPermissionsGrantedError(_ error: Error) -> Bool {
        
        guard let userInfo = error._userInfo as? [String: Any],
            let code = userInfo[FBSDKGraphRequestErrorGraphErrorCode] as? Int else { return false }
        
        return code == 200
    }
    
    /// configure the login method
    private static func configureLogin(with fbHandler: (result: FBSDKLoginManagerLoginResult?, error: Error?),
                                       _ completion: @escaping (_ response: FbResponse, _ error: Error?) -> Void) {
        
        let error = fbHandler.error
        let result = fbHandler.result
        
        if nil != error {
            if (isPermissionsGrantedError(error!)) {
                completion(.permissionNotGranted, error!)
            }
            completion(.fail, error!)
        }
        
        if let res = result {
            if res.isCancelled {
                completion(.canceled, nil)
            } else {
                completion(.success, nil)
            }
        } else {
            completion(.canceled, nil)
        }
        
    }
    
    // MARK: - Public
    
    /// facebook fetched token
    static func currentToken() -> FBSDKAccessToken {
        return FBSDKAccessToken.current()
    }
    
    /// login to Facebook, specify the publish or read permissions
    static func login(with permissions: Permissions,
                      from controller: UIViewController,
                      _ completion: @escaping (_ response: FbResponse, _ error: Error?) -> Void) {
        
        
        if (isLoggedFacebook() && permissions.isRequiredPermissionsGranted()) {
            completion(.success, nil)
        } else {
            loginManager.logIn(withReadPermissions: fbPermitions,
                               from: controller, handler: { (result, error) in
                                
                                FacebookUtility.configureLogin(with: (result, error), completion)
            })
        }
        
    }
    
    static func logout() {
        if (isLoggedFacebook()) {
            loginManager.logOut()
        }
    }
}
