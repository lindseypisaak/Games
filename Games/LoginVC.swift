//
//  LoginVC.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-04-26.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var email: LoginTextField!
    @IBOutlet weak var password: LoginTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedElsewhere()
        activityIndicator.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if let email = email.text, let password = password.text, (password.characters.count > 0 && password.characters.count > 0) {
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            AuthService.instance.login(email: email, password: password, onComplete: { (errorMessage, data) in
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                guard errorMessage == nil else {
                    self.showAlert(title: "Login Error", message: errorMessage!, handler: nil)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            })
            
        } else {
            showAlert(title: "All Fields Required", message: "You must fill out all the fields", handler: nil)
        }
    }
}
