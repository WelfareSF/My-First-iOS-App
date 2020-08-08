//
//  Utilities.swift
//  My First Offcial Project
//
//  Created by administrator on 7/2/20.
//  Copyright © 2020 Rushil. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    
    static func styleTextField(textfield: UITextField) {
        
        // this is to create the color of the bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect( x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init( red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        
        //this is to remove the border on the text field
        textfield.borderStyle = .none
        
        //this is to add the basic line for the text field
        textfield.layer.addSublayer(bottomLine)
    }
    static func styleFilledButton( button: UIButton){
        
        //this is to have the round corner style
        button.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    static func styleOpaqueButton (button: UIButton ){
        button.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        button.layer.borderWidth = 2
        button.tintColor = UIColor.white
        
    }
    static func styleHollowButton( button: UIButton){
        
        //this is to have a hollow button with rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
        
    }
    static func styleOptionButton(button: UIButton){
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = UIColor.mainBlue
        button.titleLabel?.textColor = UIColor.black
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 15.0
        
    }
    static func isPasswordValid( password: String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}" )
        return passwordTest.evaluate(with: password)
    }
    static func isValidEmail(email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
   }
    }
