//
//  InviteMemberModalVC.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-27.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

class InviteMemberModalVC: UIViewController {

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
        
    }
}
