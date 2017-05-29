//
//  MemberInviteCell.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-28.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

class MemberInviteCell: UITableViewCell {
    
    @IBOutlet weak var email: UILabel!
    
    var user: User!
    
    func configureCell(user: User) {
        self.user = user
        
        email.text = self.user.email
    }
}
