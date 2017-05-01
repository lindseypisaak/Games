//
//  AuthService.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-04-29.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias Completion = (_ errorMessage: String?, _ data: AnyObject?) -> Void

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func register(email: String, password: String, onComplete: Completion?) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            } else {
                onComplete?(nil, user)
            }
        })
        
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            } else {
                onComplete?(nil, user)
            }
        })
        
    }
    
    func requestPasswordReset() {
        
    }
    
    private func handleFirebaseError(error: NSError, onComplete: Completion?) {
        
        if let errorCode = FIRAuthErrorCode(rawValue: error.code) {
            switch (errorCode) {
                
            case .errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil)
                break
                
            case .errorCodeEmailAlreadyInUse:
                onComplete?("Email address already in use. Please try logging in", nil)
                break
                
            case .errorCodeWeakPassword:
                onComplete?("Password is too weak", nil)
                break
                
            case .errorCodeUserDisabled:
                onComplete?("User account is disabled", nil)
                break
                
            case .errorCodeWrongPassword:
                onComplete?("Incorrect password", nil)
                break
                
            case .errorCodeTooManyRequests:
                onComplete?("Number of login attempts exceeded. Please wait and try again later", nil)
                break
                
            case .errorCodeUserNotFound:
                onComplete?("User account not found", nil)
                break
                
            default:
                onComplete?("Authentication error. Please try again", nil)
            }
        }
    }
    
}
