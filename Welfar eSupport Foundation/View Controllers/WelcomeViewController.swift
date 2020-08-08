//
//  ViewController.swift
//  Welfar eSupport Foundation
//
//  Created by administrator on 7/3/20.
//  Copyright © 2020 Rushil. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       setUpElements()
     }
     func setUpElements(){

        
         Utilities.styleFilledButton(button: signUpButton)
         Utilities.styleHollowButton(button: loginButton)
        
}

}
