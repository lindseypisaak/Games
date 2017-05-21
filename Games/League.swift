//
//  League.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-03.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

struct League: Equatable {
    private var _uid: String
    private var _name: String
    
    var uid: String {
        return _uid
    }
    
    var name: String {
        return _name
    }
    
    init(uid: String, name: String) {
        _uid = uid
        _name = name
    }
    
    static func ==(lhs: League, rhs: League) -> Bool {
        return lhs.uid == rhs.uid && lhs.name == rhs.name
    }
}
