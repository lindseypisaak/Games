//
//  MemberCell.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-22.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var user: User!
    
    func configureCell(user: User) {
        self.user = user
        
        name.text = self.user.name
//        img.image = self.user.image
        img.image = #imageLiteral(resourceName: "cancel")
    }
}
