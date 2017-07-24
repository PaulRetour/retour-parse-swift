//
//  MapIconSelector.swift
//  retour
//
//  Created by Paul Lancashire on 06/07/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit

class MapIconSelector: NSObject {
    
    func selectMapIcon(placeSet: [String]) -> UIImage {
        
        print("selecting icon")
        var returnImage = UIImage()
        
        let firstString = placeSet[0]

            switch firstString {
            case "airport":
                returnImage = UIImage(named: "TransportMapIcon32.png")!
            case "train_station":
                returnImage = UIImage(named: "TransportMapIcon32.png")!
            case "subway_station":
                returnImage = UIImage(named: "TransportMapIcon32.png")!
            case "transit_station":
                returnImage = UIImage(named: "TransportMapIcon32.png")!

            default:
                returnImage = UIImage(named: "DefaultMapIcon.png")!
            }
        
        return returnImage
    }
    
}
