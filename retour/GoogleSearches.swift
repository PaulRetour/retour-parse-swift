//
//  GoogleSearches.swift
//  retour
//
//  Created by Paul Lancashire on 22/07/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import Parse

class GoogleSearches: NSObject {
    
    let APIKey = "AIzaSyC9--UMJpT046hj-geZFDzP1RXBCpbJhVU"
    
    // Function to get a google Place Review using the API
    // Pass in the markerview to populate, the place ID to retrieve and the label to populate
    func getPlacesAndPopulateMap(markerView: GMSMarker, placeID: String, textLabel: UILabel, textLabel2: UILabel) {
        Alamofire.request("https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&review_summary&key=\(APIKey)").responseJSON { (response) in
            if response != nil {
              //  print("google api response")
                let json = JSON(data: response.data!)
              //  print(json)
                let reviewsString1 = json["result"]["reviews"][0]["text"].string
                let reviewsString2 = json["result"]["reviews"][1]["text"].string
                textLabel.text = reviewsString1
                textLabel2.text = reviewsString2
            }
        }
    }
    
    func getSinglePlaceReviewForLabel(label: UILabel, placeID: String) {
    Alamofire.request("https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&review_summary&key=\(APIKey)").responseJSON { (response) in
    if response != nil {
                let json = JSON(data: response.data!)
                print("single response - \(response)")
                let review = json["result"]["reviews"][0]["text"].string
                label.text = review
                print("label text = \(review)")
            }
        }
    }
    
}
