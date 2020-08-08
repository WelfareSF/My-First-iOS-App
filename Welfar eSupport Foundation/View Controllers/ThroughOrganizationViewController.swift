//
//  ThroughOrganizationViewController.swift
//  Welfar eSupport Foundation
//
//  Created by administrator on 7/31/20.
//  Copyright © 2020 Rushil. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftUI

class ThroughOrganizationViewController: UIViewController {
  

   
    @IBOutlet weak var fundraisingLebel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var rewardPointsLabel: UILabel!
    
    @IBOutlet weak var clothingDriveLabel: UILabel!
    
    @IBOutlet weak var foodDriveLabel: UILabel!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var organizationNameTextField: UITextField!
    
    @IBOutlet weak var describeYourActivityTextField: UITextField!
    
    @IBOutlet weak var foodDriveSwitch: UISwitch!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    override func viewDidLoad(){
        super.viewDidLoad()
        setUpElements()
        
        
    }
     
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleFilledButton(button: recordButton)
    Utilities.styleTextField(textfield: dateTextField)
        Utilities.styleTextField(textfield: describeYourActivityTextField)
        Utilities.styleTextField(textfield: organizationNameTextField)
        Utilities.styleTextField(textfield: timeTextField)
}
    
           func validateFields() -> String? {     
         //Check that all fields are filled in
         if organizationNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
         dateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
         timeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
         describeYourActivityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showError(message: "Please Make Sure You Have Filled In All The Fields")
             
     }
            return nil
    }
                func showError(message: String) {
                errorLabel.text = message
                errorLabel.alpha = 1
            }
    @State private var score1 = 0
    
    
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        let error2 = foodDriveSwitch
        let error = validateFields()
        
        if error != nil{
            showError(message: "error!")
        }
              
        if error2 != nil{
                      
                     
                      
                     }

                      
              
                     else{
        let organizationName = organizationNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let time = timeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let date = dateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let describeYourActivity = describeYourActivityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        //let firstName = firstNameTextField.text!.trimmingChracters(in: .whitespacesAndNewLines)
                        guard  let userID = Auth.auth().currentUser?.uid
                            else {return}
                   let db = Firestore.firestore()

                        db.collection("users").document(userID).setData(["organizationName":organizationName, "time":time, "date":date, "describeYourActivity":describeYourActivity], merge: true)
                        func foodDriveSwitch(_ sender: UISwitch){
                            if sender.isOn{
                                score1 += 30
                                scoreLabel.text = String(score1)
                                
                                
                            }
                            else{
                                score1 = 0
                                scoreLabel.text = String(score1)
                                
                            }
                        }
                        
                       
        }

}

}


