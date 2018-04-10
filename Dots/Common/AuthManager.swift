//
//  AuthManager.swift
//  Dots
//
//  Created by Sasha on 8/1/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation
import Firebase

enum AuthError: Error {
    case emptyData
    case fail(String?)
    case failedPermissions
    
    var message: String {
        var errorMessage = ""
        
        switch self {
        case .emptyData:
            errorMessage = "Please, provide the auth data for login"
        case .fail(let message):
            errorMessage = message!
        case .failedPermissions:
            errorMessage = "Please, provide the required permissions for the auth"
        }
        
        return errorMessage
    }
}

struct AuthManager {
    /// login to facebook - > Firebase
    static func logInFacebook(_ controller: UIViewController,
                                      _ completion: @escaping (_ user: User?, _ error: AuthError?) -> Void) {
        
        FacebookUtility.login(with: .read, from: controller) { (fbResponse, error) in
            
            switch fbResponse {
            case .success:
                let credential = FacebookAuthProvider.credential(withAccessToken: FacebookUtility.currentToken().tokenString)
                configureLogin(with: credential, completion)
                break
            case .fail:
                completion(nil, .fail(error?.localizedDescription))
                break
            case .permissionNotGranted:
                
                // make logout to fetch new permissions
                FacebookUtility.logout()
                completion(nil, .failedPermissions)
                break
                
            case .canceled: completion(nil, nil)
            }
        }
    }
    
    static func signOut() {
        try! Auth.auth().signOut()
    }
    
    /// configure login completion
    private static func configureLogin(with credential: AuthCredential,
                                       _ completion: @escaping (_ user: User?, _ error: AuthError?) -> Void) {
        
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            guard let user = user else {
                guard let error = error else {
                    completion(nil, nil)
                    return
                }
                completion(nil, .fail(error.localizedDescription))
                return
            }
            completion(user, nil)
        })
    }
}
