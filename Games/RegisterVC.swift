//
//  ViewController.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-04-26.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterVC: UIViewController {

    @IBOutlet weak var email: LoginTextField!
    @IBOutlet weak var name: LoginTextField!
    @IBOutlet weak var password: LoginTextField!
    @IBOutlet weak var verifyPassword: LoginTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedElsewhere()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerPressed(_ sender: Any) {

        if let email = email.text, let name = name.text, let password = password.text, let verifiedPass = verifyPassword.text, (email.characters.count > 0 && password.characters.count > 0 && name.characters.count > 0 && password.characters.count > 0 && verifiedPass.characters.count > 0) {
            
            if password == verifiedPass {
                
                AuthService.instance.register(email: email, password: password, onComplete: { (errorMessage, data) in
                    
                    guard errorMessage == nil else {
                        self.showAlert(title: "Registration Error", message: errorMessage!, handler: nil)
                        return
                    }
                    
                    self.showAlert(title: "Registration Successful", message: "Your account has been created. Please verify via the email we've sent, then login", handler: { (alertAction) in
                        self.dismiss(animated: true, completion: nil)
                    })
                })
                
            } else {
                showAlert(title: "Passwords Must Match", message: "The password fields do not match", handler: nil)
            }
            
        } else {
            showAlert(title: "All Fields Required", message: "You must fill out all the fields", handler: nil)
        }
        
    }
}

