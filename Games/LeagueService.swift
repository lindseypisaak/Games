//
//  LeagueService.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-08.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import Foundation
import FirebaseDatabase

class LeagueService {
    private static let _instance = LeagueService()
    
    static var instance: LeagueService {
        return _instance
    }
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var leaguesRef: FIRDatabaseReference {
        return mainRef.child(DB_LEAGUES)
    }
    
    var leagueMembersRef: FIRDatabaseReference {
        return mainRef.child(DB_LEAGUEMEMBERS)
    }
    
    var leagueInvitesRef: FIRDatabaseReference {
        return mainRef.child(DB_LEAGUEINVITES)
    }
    
    func createLeague(name: String, createdByUid: String, onComplete: Completion?) {
        let leagueRef = leaguesRef.childByAutoId()
        
        let newLeague = [
            "name": name as AnyObject,
            DB_MEMBERS: [
                createdByUid: true
            ]
        ] as [String : Any]
        
        leagueRef.setValue(newLeague)
        onComplete?(nil, leagueRef.key as AnyObject)
    }
    
    func addUserToLeague(leagueId: String, userId: String) {
        leaguesRef.child(leagueId).child(DB_MEMBERS).setValue([userId: true])
    }
    
    func removeUserFromLeague(leagueId: String, userId: String) {
        leaguesRef.child(leagueId).child(DB_MEMBERS).child(userId).removeValue()
    }
    
//    func inviteUserToLeague(leagueId: String, userEmail: String) {
//        leaguesRef.child(leagueId).child(DB_INVITES).updateChildValues([userEmail: true])
//    }
    
    func removeUserFromLeagueInvites(leagueId: String, userId: String) {
        leaguesRef.child(leagueId).child(DB_INVITES).child(userId).removeValue()
    }
    
    func getLeague(leagueId: String, onComplete: @escaping (League?) -> ()) {
        leaguesRef.child(leagueId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let league = snapshot.value as? Dictionary<String, Any> {
                if let leagueName = league["name"] as? String {
                    onComplete(League(uid: leagueId, name: leagueName))
                    return
                }
            }
            
            onComplete(nil)
        })
    }
    
    
    func getGamesIdsForLeague(leagueId: String, onComplete: @escaping (Array<String>) -> ()) {
        leaguesRef.child(leagueId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let league = snapshot.value as? Dictionary<String, Any> {
                if let games = league["games"] as? Dictionary<String, Any> {
                    onComplete(games.keys.sorted())
                }
            }
            
            onComplete(Array<String>())
        })
    }
}
