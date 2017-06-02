//
//  RegistrationViewController.swift
//  retour
//
//  Created by Paul Lancashire on 23/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import JVFloatLabeledTextField
import Parse
import ReachabilitySwift

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    let standardsInfo = standards()
    
    @IBOutlet weak var spinner: InstagramActivityIndicator!
    
    var reach = Reachability()!
    
    @IBOutlet weak var emailField: JVFloatLabeledTextField!
    
    @IBOutlet weak var passwordField: JVFloatLabeledTextField!
    
    @IBOutlet weak var label: UILabel!
    
    var emailAddress = String()
    
    @IBOutlet weak var alertlabel: UILabel!
    
    override func viewDidLoad() {
        
        self.hideKeyboardWhenTappedAround()
        
      //  alertlabel.isEnabled = false
        alertlabel.isHidden = true
        
        passwordField.delegate = self
        emailField.delegate = self
        
        emailField.textColor = standardsInfo.retourGreen
        emailField.placeholderColor = standardsInfo.retourGreen
        emailField.spellCheckingType = UITextSpellCheckingType.no
        
        passwordField.textColor = standardsInfo.retourGreen
        passwordField.placeholderColor = standardsInfo.retourGreen
        passwordField.spellCheckingType = UITextSpellCheckingType.no
        
        label.textColor = standardsInfo.retourGrey
        alertlabel.textColor = standardsInfo.retourGrey
        
        spinner.strokeColor = standardsInfo.retourGreen
        spinner.isHidden = true
        spinner.lineWidth = 2
    }
    
    func checkUsername() {
        
        self.dismissKeyboard()
        
        
        // if network ok //
        if reach.isReachable {
            spinner.isHidden = false
            spinner.startAnimating()
            self.alertlabel.isHidden = true
        
            
            if emailField.text != nil {
                
                // create user lookup query //
                let userCheck = PFQuery(className: "_User")
                userCheck.whereKey("email", equalTo: emailField.text!)
                // perform user lookup query //
                userCheck.getFirstObjectInBackground(block: { (object, err) in
                    
                    if object == nil {
                        print("no user with that email")
                        self.spinner.isHidden = true
                        self.alertlabel.text = "No user with that email, carry on"
                        self.alertlabel.isHidden = false
                        self.performSegue(withIdentifier: "Registration2Segue", sender: self)
                    } else {
                        print("user already exists")
                        self.spinner.isHidden = true
                        self.alertlabel.text = "User already exists"
                        self.alertlabel.isHidden = false
                    }
                    
                })
            }
        }
            
            
         
            
        //only do the below bit if no network...
        else {
            self.alertlabel.text = "Network Unavailable"
            self.alertlabel.isHidden = false
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == passwordField {
            print("return key hit on password field- check and segue here")
            checkUsername()
        }
        if textField == emailField {
            self.passwordField.becomeFirstResponder()
        }
        return true
        }
    
}
