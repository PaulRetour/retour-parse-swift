//
//  ResetViewController.swift
//  retour
//
//  Created by Paul Lancashire on 27/09/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ResetViewController: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    
    @IBAction func resetButton(_ sender: Any) {
        
        PFUser.requestPasswordResetForEmail(inBackground: emailField.text!) { (done, error) in
            if error == nil {
                print("email sent and reset")
                self.dismiss(animated: true, completion: nil)
                
            } else {
                print("error but hey...")
                self.dismiss(animated: true
                    , completion: { 
                        
                })
            }
        }
    }
}
