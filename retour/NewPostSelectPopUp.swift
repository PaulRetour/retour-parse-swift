//
//  NewPostSelectPopUp.swift
//  retour
//
//  Created by Paul Lancashire on 08/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import ReachabilitySwift
import Presentr

class NewPostSelectPopUp: UIViewController  {
    
    var placeName: String! {
        didSet {
            placeNameLabel.text = placeName
        }
    }
    
    var placeAddress: String! {
        didSet {
            addressLabel.text = placeAddress
        }
    }
    
    var reach = Reachability()!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOpacity = 0.5
        self.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.view.layer.shadowRadius = 15
        self.view.backgroundColor = UIColor.clear
        if placeName != nil {
        print("popup placename = \(placeName)")
        }
    }

}
