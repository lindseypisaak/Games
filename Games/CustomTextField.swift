//
//  CustomTextField.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-27.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var leftViewRect = super.leftViewRect(forBounds: bounds)
        leftViewRect.origin.x += leftPaddingForImage
        return leftViewRect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.x += leftPaddingForText
        return textRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var editingRect = super.editingRect(forBounds: bounds)
        editingRect.origin.x += leftPaddingForText
        return editingRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPaddingForImage: CGFloat = 0
    @IBInspectable var leftPaddingForText: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var topLineWidth : CGFloat = 1 {
        didSet{
            let border = CALayer()
            border.borderColor = UIColor.darkGray.cgColor
            border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: topLineWidth)
            border.borderWidth = topLineWidth
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var bottomLineWidth : CGFloat = 1 {
        didSet{
            let border = CALayer()
            border.borderColor = UIColor.darkGray.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - bottomLineWidth, width: self.frame.size.width, height: self.frame.size.height)
            border.borderWidth = bottomLineWidth
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            let rawString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
            let str = NSAttributedString(string: rawString, attributes: [NSForegroundColorAttributeName: placeholderColor!])
            attributedPlaceholder = str
        }
    }
}
