//
//  GameService.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-20.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GameService {
    private static let _instance = GameService()
    
    static var instance: GameService {
        return _instance
    }
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var gamesRef: FIRDatabaseReference {
        return mainRef.child(DB_GAMES)
    }
    
    
    
    func getGame(gameId: String, onComplete: @escaping (Game?) -> ()) {
        gamesRef.child(gameId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let name = snapshot.value as? String {
                onComplete(Game(uid: gameId, name: name))
                return
            }
            
            onComplete(nil)
        })
    }
    
    func getAllGames(onComplete: @escaping (Array<Game>) -> ()) {
        gamesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let games = snapshot.value as? Dictionary<String, String> {
                var gamesToReturn = [Game]()
                
                for game in games {
                    gamesToReturn.append(Game(uid: game.key, name: game.value))
                }
                
                onComplete(gamesToReturn)
                return
            }
            
            onComplete([Game]())
        })
    }
}
