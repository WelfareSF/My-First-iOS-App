//
//  LogoViewController.swift
//  Welfar eSupport Foundation
//
//  Created by administrator on 7/19/20.
//  Copyright © 2020 Rushil. All rights reserved.
//


import UIKit

class LogoViewController: UIViewController {

    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var mapButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        profileButton.alpha = 0.75
        mapButton.alpha = 0.75
        
        Utilities.styleFilledButton(button: profileButton)
        Utilities.styleFilledButton(button: mapButton)
    

}
    func transistionToHome(){
        let homeViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    func transistionToProfile(){
        let profileViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileViewController) as? ProfileViewController
        view.window?.rootViewController = profileViewController
        view.window?.makeKeyAndVisible()
    }
    @IBAction func mapButtonTapped(_ sender: Any) {
        transistionToHome()
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        transistionToProfile()
    }
    
}
