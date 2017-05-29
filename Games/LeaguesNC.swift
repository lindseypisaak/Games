//
//  LeaguesNC.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-12.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

class LeaguesNC: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
