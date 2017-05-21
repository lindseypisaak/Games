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
    
    override func viewDidAppear(_ animated: Bool) {
        print(FIRAuth.auth()?.currentUser?.email ?? "No user")
        
        guard FIRAuth.auth()?.currentUser == nil else {
            segueToLeagues()
            return
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        password.text = ""
        verifyPassword.text = ""
    }
    
    func segueToLeagues() {
        let leagues = LeaguesNC.instantiate(fromAppStoryboard: .Leagues)
        present(leagues, animated: true, completion: nil)
    }
    
    @IBAction func emailPrimaryActionTriggered(_ sender: Any) {
        name.becomeFirstResponder()
    }
    
    @IBAction func namePrimaryActionTriggered(_ sender: Any) {
        password.becomeFirstResponder()
    }
    
    @IBAction func passwordPrimaryActionTriggered(_ sender: Any) {
        verifyPassword.becomeFirstResponder()
    }
    
    @IBAction func verifyPasswordPrimaryActionTriggered(_ sender: Any) {
        registerPressed(sender)
    }
    
    @IBAction func registerPressed(_ sender: Any) {

        if let email = email.text, let name = name.text, let password = password.text, let verifiedPass = verifyPassword.text, (email.characters.count > 0 && password.characters.count > 0 && name.characters.count > 0 && password.characters.count > 0 && verifiedPass.characters.count > 0) {
            
            if password == verifiedPass {
                
                ActivitySpinnerView.instance.showProgressView(view)
                
                AuthService.instance.register(email: email, password: password, name: name, onComplete: { (errorMessage, data) in
                    
                    ActivitySpinnerView.instance.hideProgressView()
                    
                    guard errorMessage == nil else {
                        self.showAlert(title: "Registration Error", message: errorMessage!, handler: nil)
                        return
                    }
                    
                    self.segueToLeagues()
                })
                
            } else {
                showAlert(title: "Passwords Must Match", message: "The password fields do not match", handler: nil)
            }
            
        } else {
            showAlert(title: "All Fields Required", message: "You must fill out all the fields", handler: nil)
        }
        
    }
}

