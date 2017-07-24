//
//  SavingViewController.swift
//  Pods
//
//  Created by Paul Lancashire on 16/06/2017.
//
//

import Foundation
import UIKit

class SavingViewController: UIViewController {
    
    let spin = InstagramActivityIndicator()
    
    @IBOutlet var spinner: InstagramActivityIndicator!
    
    override func viewDidLoad() {
        spinner.startAnimating()
    }
}
