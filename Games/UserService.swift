//
//  DatabaseService.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-03.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserService {
    private static let _instance = UserService()
    
    static var instance: UserService {
        return _instance
    }
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var usersRef: FIRDatabaseReference {
        return mainRef.child(DB_USERS)
    }
    
    func saveUser(user: User) {
        let profile: Dictionary<String, AnyObject> = ["email": user.email as AnyObject, "name": user.name as AnyObject]
        usersRef.child(user.uid).setValue(profile)
    }
    
    func addLeagueToUser(userId: String, leagueId: String) {
        usersRef.child(userId).child(DB_LEAGUES).updateChildValues([leagueId: true])
    }
    
    func addLeagueToUserInvites(userId: String, leagueId: String) {
        usersRef.child(userId).child(DB_INVITES).updateChildValues([leagueId: true])
    }
    
    func removeLeagueFromUser(userId: String, leagueId: String) {
        usersRef.child(userId).child(DB_LEAGUES).child(leagueId).removeValue()
    }
    
    func removeLeagueFromUserInvites(userId: String, leagueId: String) {
        usersRef.child(userId).child(DB_INVITES).child(leagueId).removeValue()
    }
    
    func getLeagueIdsForUser(userId: String, onComplete: @escaping (Array<Array<String>>) -> ()) {
        
        usersRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let user = snapshot.value as? Dictionary<String, Any> {
                var leaguesToReturn = [[String]()]
                
                if let leagues = user["leagues"] as? Dictionary<String, Any> {
                    leaguesToReturn.append(leagues.keys.sorted())
                }
                
                if let invites = user["invites"] as? Dictionary<String, Any> {
                    leaguesToReturn.append(invites.keys.sorted())
                }
                
                onComplete(leaguesToReturn)
            }
            
            onComplete(Array<Array<String>>())
        })
    }
}
