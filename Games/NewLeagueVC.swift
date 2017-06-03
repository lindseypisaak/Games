//
//  NewLeagueVC.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-06.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewLeagueVC: UIViewController {
    
    private var userId: String?
    @IBOutlet weak var leagueName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userId = FIRAuth.auth()?.currentUser?.uid
    }

    @IBAction func cancelPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        LeagueService.instance.createLeague(name: leagueName.text!, createdByUid: userId!, onComplete: { (error, leagueId) in
            
            guard error == nil else {
                self.showAlert(title: "Could Not Create League", message: error!, handler: nil)
                return
            }
            
            UserService.instance.addLeagueToUser(userId: self.userId!, leagueId: leagueId as! String)
        })
        
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
