//
//  SignUpViewController.swift
//  Welfar eSupport Foundation
//
//  Created by administrator on 7/3/20.
//  Copyright © 2020 Rushil. All rights reserved.
//
import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
        func setUpElements(){
        errorLabel.alpha = 0
        
        Utilities.styleTextField(textfield: firstNameTextField)
        Utilities.styleTextField(textfield: lastNameTextField)
        Utilities.styleTextField(textfield: emailTextField)
        Utilities.styleTextField(textfield: passwordTextField)
        Utilities.styleFilledButton(button: signUpButton)

    }
       func validateFields() -> String? {
        
            //Check that all fields are filled in
            if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                showError(message: "Please Fill In All The Fields.")
        }
              //To check if the password is secure
                  let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                  
                  if Utilities.isPasswordValid(password: cleanedPassword) == false{
                      //Password is not secure enough
                    showError(message:"Please make sure that the Password is at least Eight Charaters Long, contains a Special Character and Number")
                  }
        
               let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                if Utilities.isValidEmail(email: cleanedEmail) == false{
               // email is invalid
                    showError(message:"Please make sure you are using the right eamil address")
                
       }
    
            
    return nil
    }
                    
    @IBAction func signUpTapped(_ sender: Any) {
         let error = validateFields()
        
               if error != nil{
                
                //there is something wrong with the fields show error message
                showError(message: "error!")
                //transistionToWelcome()
                
               }
                
        
        else{
                
                //Create Cleaned versions of the data
                let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                //create the user
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                    
                    //Check for error
                    if err != nil{
                        
                        //There was an error creating the user
                        self.showError(message: "1) Make sure that you have filled in all the fields.                                                            2) Make sure you entered a valid email address.                                                                                     3) Make sure that you have created a Password that contains 8 Characters, A Number, and A Special Character")
                    }
                    else{
                       let db = Firestore.firestore()
                        Auth.auth().currentUser?.sendEmailVerification()
                        db.collection("users").addDocument(data: ["firstName":firstName, "lastName":lastName, "uid": result!.user.uid]) {(error) in
                            if error != nil {
                            // Show error message
                                self.showError(message: "User Data could not be saved")
                                
                              
                                
                            }
            }
                        
                        //Transistion to the home screen
                        self.transistionToLogo()
        }
                    
    }
                    
        
                    
       
        }

    }
  
        func showError(message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transistionToWelcome(){
       let welcomeViewController =
        storyboard?.instantiateViewController(identifier: Constants.Storyboard.welcomeViewController) as? WelcomeViewController
    view.window?.rootViewController = welcomeViewController
    view.window?.makeKeyAndVisible()
}
        func transistionToHome(){
        
        let homeViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    func transistionToLogo(){
        let logoViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.logoViewController) as? LogoViewController
        view.window?.rootViewController = logoViewController
        view.window?.makeKeyAndVisible()
    }
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     
     }
    */
    // check the fields and validate that the data is correct. If everything is correct, this method will return nil. Otherwise it returns the error message
    
        //validate the fields
   
       
                    

            
  
            //Validate the fields
            //Validate the fields
    //create the user
    // transition to the home screen
