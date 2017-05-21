//
//  AuthService.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-04-29.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func register(email: String, password: String, name: String, onComplete: Completion?) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            } else {
                
                // Save user to database
                UserService.instance.saveUser(user: User(uid: user!.uid, email: email, name: name))
                onComplete?(nil, user)
            }
        })
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            } else {
                
                // Only login if the user is verified
//                if FIRAuth.auth()?.currentUser?.isEmailVerified == true {
                    onComplete?(nil, user)
//                } else {
//                    self.sendUserVerificationEmail(onComplete: onComplete)
//                }
            }
        })
    }
    
    func requestPasswordReset(email: String, onComplete: Completion?) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            } else {
                onComplete?(nil, nil)
            }
        })
    }
    
//    func sendUserVerificationEmail(onComplete: Completion?) {
//        FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
//            if error != nil {
//                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
//            } else {
//                onComplete?(nil, nil)
//            }
//        })
//    }
    
    func signOut(onComplete: Completion?) {
        do {
            try FIRAuth.auth()?.signOut()
            onComplete?(nil, nil)
        } catch let signOutError as NSError {
            handleFirebaseError(error: signOutError, onComplete: onComplete)
        }
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
                
            case .errorCodeKeychainError:
                onComplete?("Keychain error", nil)
                
            default:
                onComplete?("Authentication error. Please try again", nil)
            }
        }
    }
    
}
