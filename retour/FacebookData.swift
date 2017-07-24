//
//  FacebookData.swift
//  retour
//
//  Created by Paul Lancashire on 15/07/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class FacebookData: NSObject {
    
 //   let FBplaceJSON = JSON()!
  //  let FBreviewsJSON =
    
    // To get a place by name - e.g. the neptune whitstable
   // curl -i -X GET \
   // "https://graph.facebook.com/v2.9/search?type=place&q=the%20neptune%20whitstable&access_token=648039025288938%7CsJA3UiqKrePCUzLlw7eZKqxXHGM"
    
    // To get the details of a place when you have the id..
    // curl -i -X GET \
    //"https://graph.facebook.com/v2.9/1039250819453399?fields=location%2Cposts.limit(3)&access_token=648039025288938%7CsJA3UiqKrePCUzLlw7eZKqxXHGM"
    
    // from here you can get posts - for each post get the id, and request id plus -
    
    
    // or look for places near current location - maybe limit (5)
    //  curl -i -X GET \
    // "https://graph.facebook.com/v2.9/search?type=place&center=51.35709%2C1.026593&distance=1000&limit=5&access_token=648039025288938%7CsJA3UiqKrePCUzLlw7eZKqxXHGM"
  
    func SpecificPlaceSearchFB(coord: CLLocationCoordinate2D, placeName: String!) {
       
        // Implement alamofire query with coords and place name to retrieve a place ID
       // GET https://graph.facebook.com/v2.9/search?type=place&{parameters}&fields={place information}
        let access_token = "EAACEdEose0cBAMPdVxJXi9qluzFOhRRsQsIFRB4laUW513PHqZCn4gOcWjrLDzYBZCUMuIkU0nn71fcff81I5gAhLUAkseh1A3Fu3d4sBPoBCeDMZCXvUzr69u6QqL26e9ZCClRwZBR7LrAD3TVmUwWZCEuqWFWeBEfO7MQZBZBRbtmYBPrBkxscoZCY1jW7uCZAxn9QHZCZArsshQZDZD"
        }
    
    func localPlacesWithLimit(coord: CLLocationCoordinate2D, limit: Int) {
        
        
        
    }
}
    
