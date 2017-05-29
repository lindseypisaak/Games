//
//  PendingInviteCell.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-06.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit
import SwipeCellKit

class PendingInviteCell: SwipeTableViewCell {
    
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var invitedByEmail: UILabel!
    
    var league: League!
    
    func configureCell(league: League) {
        self.league = league
        
        leagueName.text = league.name
    }
}
