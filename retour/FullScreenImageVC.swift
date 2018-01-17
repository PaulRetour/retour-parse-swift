//
//  FullScreenImageVC.swift
//  Pods
//
//  Created by Paul Lancashire on 21/09/2017.
//
//

import Foundation
import UIKit

class FulLScreenImageVC: UIViewController {
    
    var incomingImage: UIImage!
    
    @IBOutlet var imageviewer: UIImageView!
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imageviewer.image = incomingImage!
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
