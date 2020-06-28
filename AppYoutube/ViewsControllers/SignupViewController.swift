//
//  SignupViewController.swift
//  App1FirebasAuth
//
//  Created by Nadia Mettioui on 18/04/2020.
//  Copyright © 2020 Nadia Mettioui. All rights reserved.
//

import UIKit
import Firebase



class SignupViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        // Do any additional setup after loading the view.
    }
    
    func setupElements(){
        //Hide the error label
        errorLabel.alpha = 0
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(passWordTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }
    // chck fields and validata the data correct?
    //return nill else error
    
    func validateFields() -> String?{
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  ||
            passWordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill all fields"
        }
        // check if pasw is secure
        let cleanPswd = passWordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanPswd) == false {
            return "Please make sur your password is at least 8 char, a special char and a number "
        }
        
        return nil
        
    }

  
    
    
    
    @IBAction func SignUpTapped(_ sender: Any) {
        // validate the fileds
        let error =  validateFields()
        if error != nil {
            //error with the fields
            showError(error!)
        }
        //create cleaned Fieldsversion of the data
        let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password =  passWordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email =  (emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        // create the user
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            //check error
            if  err != nil {
                
                // there wad a error creating user
                self.showError("Error creating user")
            }
            else {
                // user was created successfully, store de firstname and lastname
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["firstname": firstname,"lastname":lastname, "uid": result!.user.uid ]) { (error) in
                    if error != nil {
                        //show error
                        self.showError("error saving user data")
                    }
                    
            }
                // transition to the homeview
                self.transitionToHome()
            
        }
        
      }
    }
    
            func  transitionToHome(){
//                let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboars.HomeViewController) as? HomeViewController
//                view.window?.rootViewController = homeViewController
//                view.window?.makeKeyAndVisible()
//                
            
        }
    
    
    
    
    
    
    
    func showError(_ message : String) {
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    
}
