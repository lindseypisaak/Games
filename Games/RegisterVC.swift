//
//  ViewController.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-04-26.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var email: LoginTextField!
    @IBOutlet weak var name: LoginTextField!
    @IBOutlet weak var password: LoginTextField!
    @IBOutlet weak var verifyPassword: LoginTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerPressed(_ sender: Any) {
    }

}

