//
//  ProfileViewController.swift
//  Welfar eSupport Foundation
//
//  Created by administrator on 7/24/20.
//  Copyright © 2020 Rushil. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController{
   lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        
        view.addSubview(profileImageView)
    profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    profileImageView.anchor(top: view.topAnchor, paddingTop: 88, width: 120, height: 120)
    profileImageView.layer.cornerRadius = 120/2
    
    view.addSubview(backButton)
    backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 64, paddingLeft: 32, width: 32, height: 32)
    
    view.addSubview(rewardsButton)
    rewardsButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 64, paddingRight: 32, width: 32, height: 32)
    
    view.addSubview(nameLabel)
    nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 12)
        
//   view.addSubview(organizationButton)
  //  organizationButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 10, paddingBottom: -300, width: 190, height: 50)
    
   //  view.addSubview(individualButton)
  // individualButton.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: -300, paddingRight: 10, width: 180, height: 50)
    return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "WSF initials-removebg-preview")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .red
        return iv
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysOriginal), for: .normal)
      button.addTarget(self, action: #selector(handleBackUser), for: .touchUpInside)
        return button
    }()

 // let organizationButton: UIButton = {
    //let button = UIButton.init(type: .system)
    //button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
    //button.setTitle("Through Organization", for: .normal)
   // button.layer.borderWidth = 5.0
   // button.layer.borderColor = UIColor.mainBlue.cgColor
   // button.backgroundColor = UIColor.black
   // button.titleLabel?.textColor = UIColor.white
    //button.tintColor = UIColor.white
   //button.layer.cornerRadius = 15.0
    //return button
//}()
    func setUpElements(){
 Utilities.styleOptionButton(button: individualButton)
        Utilities.styleOptionButton(button: throughorganizationButton)
    }
     //let individualButton: UIButton = {
    //let button = UIButton.init(type: .system)
     //button.setTitle("Individual", for: .normal)
     // button.layer.borderWidth = 5.0
      // button.layer.borderColor = UIColor.mainBlue.cgColor
      // button.backgroundColor = UIColor.black
      // button.titleLabel?.textColor = UIColor.white
      // button.tintColor = UIColor.white
        //button.layer.cornerRadius = 15.0
   //  button.addTarget(self, action: #selector(handleIndividualUser), for: .touchUpInside)
       // return button
 // }()
    let rewardsButton: UIButton = {
         let button = UIButton(type: .system)
         button.setImage(#imageLiteral(resourceName: "tracker-removebg-preview").withRenderingMode(.alwaysOriginal), for: .normal)
         return button
     }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Welfare Support Foundation Member"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    @IBOutlet weak var throughorganizationButton: UIButton!
    
    @IBAction func individualButtonTapped(_ sender: Any) {
        transistionToThroughOrganization()
    }
    @IBOutlet weak var individualButton: UIButton!
    @IBAction func throughorganizationButtonTapped(_ sender: Any) {
        transistionToThroughOrganization()
    }
    override func viewDidLoad() {
            super.viewDidLoad()
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor,right: view.rightAnchor, height: 300)
        setUpElements()
        
        
        
        }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    @objc func handleBackUser(){
       return transistionToThroughOrganization()
    }
    @objc func buttonClicked(_ sender:UIButton!){
       return transistionToThroughOrganization()
    }
    @objc func handleIndividualUser(){
       return  transistionToWelcome()
    }
    func transistionToThroughOrganization(){
            let throughOrganizationViewController =
                storyboard?.instantiateViewController(identifier: Constants.Storyboard.throughOrganizationViewController) as? ThroughOrganizationViewController
            view.window?.rootViewController = throughOrganizationViewController
            view.window?.makeKeyAndVisible()
        }
    func transistionToHome(){
        let homeViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    func transistionToWelcome(){
        let welcomeViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.welcomeViewController) as? WelcomeViewController
        view.window?.rootViewController = welcomeViewController
        view.window?.makeKeyAndVisible()
    }
    
}
extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    static let mainBlue = UIColor.rgb(red: 0, green: 150, blue: 255)
}
 extension UIView{
        func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0, paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil){
            translatesAutoresizingMaskIntoConstraints = false
            if let top = top{
                topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
            }
            if let left = left{
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
            }
            if let bottom = bottom{
                if let paddingBottom = paddingBottom{
                    bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
            }
            if let right = right{
                if let paddingRight = paddingRight{
                    rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
            }
            if let width = width{
                widthAnchor.constraint(equalToConstant: width).isActive = true
            }
             if let height = height{
                       heightAnchor.constraint(equalToConstant: height).isActive = true
                   }
        }
    }



