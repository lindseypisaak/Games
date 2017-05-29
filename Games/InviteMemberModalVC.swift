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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendInvite(_ sender: Any) {
        
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
