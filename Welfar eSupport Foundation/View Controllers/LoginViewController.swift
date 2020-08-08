//
//  LoginViewController.swift
//  Welfar eSupport Foundation
//
//  Created by administrator on 7/3/20.
//  Copyright © 2020 Rushil. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       setUpElements()
     }
     func setUpElements(){
         errorLabel.alpha = 0
         
    
         Utilities.styleTextField(textfield: emailTextField)
         Utilities.styleTextField(textfield: passwordTextField)
         Utilities.styleHollowButton(button: loginButton)


}


    @IBAction func loginTapped(_ sender: Any) {
    
    
    //Validate Text Fields
        func validateFields() -> String? {
            
                //Check that all fields are filled in
                if
                emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                   showError(message: "Please Fill In All The Fields.")
            }
                  //To check if the password is secure
                      let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                      
                      if Utilities.isPasswordValid(password: cleanedPassword) == false{
                          //Password is not secure enough
                        showError(message: "Please make sure that the Password is at least Eight Charaters Long, contains a Special Character and a Number")
                      }
            
                   let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    if Utilities.isValidEmail(email: cleanedEmail) == false{
                   // email is invalid
                        showError(message:"Please make sure you are using the right eamil address")
           }
        
                
        return nil
        }
        func showError(message: String) {
            errorLabel.text = message
            errorLabel.alpha = 1
        }
        
        //Create cleaned versions of the data
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //Log in
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                //couldnt sign in
                self.errorLabel.text = error?.localizedDescription
                self.errorLabel.alpha = 1
                
            }
            else{
                
                        let logoViewController =
                            self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.logoViewController) as? LogoViewController
                            self.view.window?.rootViewController = logoViewController
                            self.view.window?.makeKeyAndVisible()
                    
                }
            }
    }
    }

