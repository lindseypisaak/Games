//
//  GamesNC.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-14.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

class GamesNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 19)!,
            NSForegroundColorAttributeName: UIColor.white
        ]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
