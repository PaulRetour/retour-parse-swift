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
    
    @IBOutlet var labelBackground: UIView!
    
    var userToSave = PFUser()
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func registerButtonPress(_ sender: Any) {
        print("registering")
        checkUsername()
    }
    
    @IBOutlet weak var spinner: InstagramActivityIndicator!
    
    var reach = Reachability()!
    
    @IBOutlet weak var emailField: JVFloatLabeledTextField!
    
  //  @IBOutlet weak var label: UILabel!
    
    var emailAddress = String()
    
    @IBOutlet weak var alertlabel: UILabel!
    
    override func viewDidLoad() {
        
        labelBackground.layer.cornerRadius = 5
        labelBackground.alpha = 0.6
        self.hideKeyboardWhenTappedAround()
        alertlabel.isHidden = true
        emailField.delegate = self
        emailField.textColor = standardsInfo.retourGreen
        emailField.placeholderColor = standardsInfo.retourGreen
        emailField.spellCheckingType = UITextSpellCheckingType.no
        alertlabel.textColor = standardsInfo.retourGrey
        spinner.strokeColor = standardsInfo.retourGreen
        spinner.isHidden = true
        spinner.lineWidth = 3
    }
    
    func checkUsername() {
        print("checking mail address")
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
                        // send email here... //
                        self.performSegue(withIdentifier: "Registration2Segue", sender: self)
                    } else {
                        print("user already exists")
                        self.spinner.isHidden = true
                        self.alertlabel.text = "User already exists"
                        self.alertlabel.isHidden = false
                    }
                })
            }
        } else {
            self.alertlabel.text = "Network Unavailable"
            self.alertlabel.isHidden = false
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dst = segue.destination as! Registration2ViewController
        userToSave.email = emailField.text
        userToSave.username = emailField.text
        print("dst = \(self.userToSave)")
        dst.userToSave = self.userToSave
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            checkUsername()
        }
        return true
        }
    
}
