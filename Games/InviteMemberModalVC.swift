//
//  InviteMemberModalVC.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-27.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit
import FirebaseAuth

class InviteMemberModalVC: UIViewController {

    var league: League!
    @IBOutlet weak var email: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        email.becomeFirstResponder()
        self.hideKeyboardWhenTappedElsewhere()
    }
    
    @IBAction func dismissModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendInvite(_ sender: Any) {
        if let email = email.text, email.characters.count > 0 {
            UserService.instance.addLeagueToUserInvites(emailToInvite: email, currentUserEmail: FIRAuth.auth()?.currentUser?.email ?? "", leagueId: league.uid, onComplete: { (invitedUid) in
                
                if let invitedUid = invitedUid {
                    LeagueService.instance.inviteUserToLeague(leagueId: self.league.uid, userId: invitedUid)
                    self.dismissModal(sender)
                } else {
                    self.showAlert(title: "User Not Found", message: "The email entered is not registered in this app", handler: { (action) in
                        self.email.text = ""
                        self.email.becomeFirstResponder()
                    })
                }
            })
        } else {
            showAlert(title: "Invalid Email", message: "Please enter an email address", handler: nil)
        }
    }
    
    @IBAction func emailPrimaryActionTriggered(_ sender: Any) {
      //  sendInvite(sender)
    }
}
