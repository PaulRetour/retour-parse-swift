//
//  MyMenuVC.swift
//  retour
//
//  Created by Paul Lancashire on 10/07/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit

class MyMenuVC: UIViewController {
    
    weak var delegate:MyMenuVCDelegate?

    @IBAction func myBlogsButton(_ sender: Any) {
        self.delegate!.setChosenScreen(id: 2)
        print("myBlogsButton")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favouriteButton(_ sender: Any) {

        print("favouriteButton")
        self.delegate!.setChosenScreen(id: 1)
        self.dismiss(animated: true, completion: nil)
    }
    
}

protocol MyMenuVCDelegate: class {
    
     func setChosenScreen(id: Int)

}

