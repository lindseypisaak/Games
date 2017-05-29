//
//  ModalView.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-27.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

@IBDesignable
class ModalView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
