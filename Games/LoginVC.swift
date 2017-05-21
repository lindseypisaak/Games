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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedElsewhere()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        password.text = ""
    }
    
    @IBAction func emailPrimaryActionTriggered(_ sender: Any) {
        password.becomeFirstResponder()
    }
    
    @IBAction func passwordPrimaryActionTriggered(_ sender: Any) {
        loginPressed(sender)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if let email = email.text, let password = password.text, (password.characters.count > 0 && password.characters.count > 0) {
            
            ActivitySpinnerView.instance.showProgressView(view)
            
            AuthService.instance.login(email: email, password: password, onComplete: { (errorMessage, data) in
                
                ActivitySpinnerView.instance.hideProgressView()
                
                guard errorMessage == nil else {
                    self.showAlert(title: "Login Error", message: errorMessage!, handler: nil)
                    return
                }
                
//                guard data != nil else {
//                    self.showAlert(title: "Verification Required", message: "You must verify your account before logging in. Please check your email and follow the verification link", handler: nil)
//                    return
//                }
                
                let leagues = LeaguesNC.instantiate(fromAppStoryboard: .Leagues)
                self.present(leagues, animated: true, completion: nil)
            })
            
        } else {
            showAlert(title: "All Fields Required", message: "You must fill out all the fields", handler: nil)
        }
    }
}
