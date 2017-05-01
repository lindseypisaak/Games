//
//  HideKeyboardExtension.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-04-30.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedElsewhere() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
