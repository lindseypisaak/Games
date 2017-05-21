//
//  Game.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-14.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import Foundation

class Game: Equatable {
    
    private var _uid: String!
    private var _name: String!
    
    var uid: String {
        return _uid
    }
    
    var name: String {
        return _name
    }
    
    init(uid: String, name: String) {
        self._uid = uid
        self._name = name
    }
    
    static func ==(lhs: Game, rhs: Game) -> Bool {
        return lhs.uid == rhs.uid && lhs.name == rhs.name
    }
}
