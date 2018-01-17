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
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: false) { 
            
        }
    }
    @IBOutlet weak var emailField: JVFloatLabeledTextField!
    
    @IBOutlet var labelBackgrounc: UIView!
    
    @IBOutlet weak var passwordField: JVFloatLabeledTextField!
    
    @IBOutlet var loginOutlet: UIButton!
    
    
    @IBOutlet var alertLabel: UILabel!
    
    @IBAction func loginButton(_ sender: Any) {
        
        self.alertLabel.isHidden = true
        
    var user = PFUser()
        print("attempting login")
        
        PFUser.logInWithUsername(inBackground: emailField.text!, password: passwordField.text!) { (user, error) in
            if error == nil {
                print("login successful")
                print(user)

                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                
            } else {
                print("do something here - cannot login")
                self.alertLabel.isHidden = false
            }
        }
        
    }
    
    func startSpinning() {
        
    }

    func stopSpinning() {
        
    }
    
    override func viewDidLoad() {
        alertLabel.isHidden = true
        hideKeyboardWhenTappedAround()
        labelBackgrounc.layer.cornerRadius = 5
        labelBackgrounc.alpha = 0.6
        emailField.alpha = 0.9
        passwordField.alpha = 0.9
        loginOutlet.backgroundColor = st.retourGreen
        passwordField.placeholderColor = st.retourGreen
        emailField.placeholderColor = st.retourGreen
        passwordField.floatingLabelTextColor = st.retourGrey
        emailField.floatingLabelTextColor = st.retourGrey
        
        loginOutlet.layer.cornerRadius = 5
    }
    
}


