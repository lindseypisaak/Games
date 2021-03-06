//
//  GameCell.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-14.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    
    var game: Game!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
        
//        layer.shadowOpacity = 0.5
//        layer.shadowOffset = CGSize(width: -2, height: 2)
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowRadius = 2.0
    }
    
    func configureCell(game: Game) {
        self.game = game
        
        gameTitle.text = self.game.name
        thumbnail.image = UIImage(named: "\(self.game.uid)")
    }
}
