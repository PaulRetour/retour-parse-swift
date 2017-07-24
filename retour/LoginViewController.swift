//
//  LoginViewController.swift
//  retour
//
//  Created by Paul Lancashire on 14/06/2017.
//  Copyright © 2017 toucan. All rights reserved.
//
//  All Parse User Only Logins are controlled by adding a second username field. //
//  pfuser.username and pfuser.email are identical //

import Foundation
import UIKit
import JVFloatLabeledTextField
import Parse

class LoginViewController: UIViewController {
    
    let st = standards()
    
    @IBOutlet weak var emailField: JVFloatLabeledTextField!
    
    @IBOutlet var labelBackgrounc: UIView!
    
    @IBOutlet weak var passwordField: JVFloatLabeledTextField!
    
    @IBOutlet var loginOutlet: UIButton!
    
    @IBAction func loginButton(_ sender: Any) {
        
    var user = PFUser()
        print("attempting login")
        
        PFUser.logInWithUsername(inBackground: emailField.text!, password: passwordField.text!) { (user, error) in
            if error == nil {
                print("login successful")
                print(user)

                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                
            }
        }
        
    }

    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        labelBackgrounc.layer.cornerRadius = 5
        labelBackgrounc.alpha = 0.6
        emailField.alpha = 0.9
        passwordField.alpha = 0.9
        loginOutlet.backgroundColor = st.retourGreen
        
        loginOutlet.layer.cornerRadius = 5
    }
    
}


