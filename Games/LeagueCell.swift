//
//  LeagueCell.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-06.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit
import SwipeCellKit

class LeagueCell: SwipeTableViewCell {
    
    @IBOutlet weak var leagueName: UILabel!
    
    var league: League!
    
    func configureCell(league: League) {
        self.league = league
        
        leagueName.text = league.name
    }
}
