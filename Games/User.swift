//
//  User.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-06.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

struct User: Equatable {
    private var _uid: String
    private var _email: String
    private var _name: String
    private var _image: UIImage?
    
    var uid: String {
        return _uid
    }
    
    var email: String {
        return _email
    }
    
    var name: String {
        return _name
    }
    
    var image: UIImage? {
        return _image
    }
    
    init(uid: String, email: String, name: String) {
        _uid = uid
        _email = email
        _name = name
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid && lhs.email == rhs.email && lhs.name == rhs.name
    }
}
