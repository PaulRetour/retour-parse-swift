//
//  SingleImageTableViewCell.swift
//  retour
//
//  Created by Paul Lancashire on 28/06/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Presentr

class SingleImageTableViewCell: UITableViewCell {

    
    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var tagsLabel: UILabel!
    @IBOutlet var image1File: UIImageView!
    
    @IBOutlet var userImage: UIImageView!
    
    @IBAction func flight1Button(_ sender: Any) {
        print("flight 1 button")
        var popUp = Presentr(presentationType: .popup)
        let FlightPopUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FlightPopUpViewController") as! FlightPopUpViewController
        
        
    }
    

}
