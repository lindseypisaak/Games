//
//  AlertExtension.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-04-30.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        present(alert, animated: true, completion: nil)
    }
    
}
