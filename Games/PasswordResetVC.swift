//
//  PasswordResetVC.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-04-26.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit
import FirebaseAuth

class PasswordResetVC: UIViewController {

    @IBOutlet weak var email: LoginTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedElsewhere()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailPrimaryActionTriggered(_ sender: Any) {
        submitPressed(sender)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        
        if let email = email.text, email.characters.count > 0 {
            
            ActivitySpinnerView.instance.showProgressView(view)
            
            AuthService.instance.requestPasswordReset(email: email, onComplete: { (errorMessage, data) in
                
                ActivitySpinnerView.instance.hideProgressView()
                
                guard errorMessage == nil else {
                    self.showAlert(title: "Password Reset Failed", message: errorMessage!, handler: nil)
                    return
                }
                
                self.showAlert(title: "Email Sent", message: "A password reset email has been sent to \(email)", handler: { (alertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
            })
        } else {
            showAlert(title: "Email Required", message: "You must enter an email address", handler: nil)
        }
        
        
    }

    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
