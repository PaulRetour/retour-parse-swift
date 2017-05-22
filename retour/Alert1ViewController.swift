//
//  Alertt1ViewController.swift
//  retour
//
//  Created by Paul Lancashire on 17/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit

class Alert1ViewController: UIViewController {
    
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBAction func okButton(_ sender: Any) {
        print(self.presentingViewController)

        self.dismiss(animated: true, completion: nil)
        if presentingViewController?.nibName == "NewPostController" { self.presentingViewController?.performSegue(withIdentifier: "cancelFromNewPostWithSender", sender: self.presentingViewController) }

    }
    
    @IBOutlet weak var okButtonImage: UIButton!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        
      //  self.view.addSubview(okButtonImage)

    }
}
