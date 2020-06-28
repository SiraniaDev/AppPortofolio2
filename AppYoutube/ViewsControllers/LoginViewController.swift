//
//  LoginViewController.swift
//  App1FirebasAuth
//
//  Created by Nadia Mettioui on 18/04/2020.
//  Copyright © 2020 Nadia Mettioui. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupElements()
        // Do any additional setup after loading the view.
        
    }
    func setupElements(){
    //Hide the error label
    errorLabel.alpha = 0
    // style element
    Utilities.styleTextField(emailTextField)
    Utilities.styleTextField(passwordTextField)
    Utilities.styleHollowButton(loginButton)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func loginTapped(_ sender: Any) {
        //validate data cf signupvc
        //cleaned data
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let psw = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //sign in
        Auth.auth().signIn(withEmail: email, password: psw) {
            (result,error) in
            if error != nil {
                //couldn t sign in
                self.errorLabel.text = error?.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
//                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboars.HomeViewController) as? HomeViewController
//                self.view.window?.rootViewController = homeViewController
//                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
}
