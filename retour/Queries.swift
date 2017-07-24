//
//  Queries.swift
//  retour
//
//  Created by Paul Lancashire on 07/06/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Parse
import CoreLocation
import ReachabilitySwift

public class Queries {
    
    let defaults = UserDefaults.standard
    let ageRangeCalc = AgeRangeCalculator()
    var reach = Reachability()
    let appD = UIApplication.shared.delegate as! AppDelegate
    
    var resultsToPass = [PFObject]()

    // findAllPosts - send in string (if any) and pull preferences in to complete search //
    
    func findAllPosts(searchString: String) {
    print("find all posts")
    let query = PFQuery(className: "blogs")
}
    
    
//    func findPostsWithHandler(closure: () -> [PFObject]) {
//        var myLocation = appD.retourLocationManager.location
//        var query = PFQuery(className: "blogs")
//        //  query.whereKey("GMSPlaceGeo", nearGeoPoint: pfGeoFromCLLocation, withinMiles: 1000)
//        query.findObjectsInBackground(block: { (object, error) in
//            self.resultsToPass = object!
//        })
//
//        return object
//    }
    
    func find(completion: () -> Void ) {
        

    }

    
    // add more function to this one - pass in search text, but call prefs //
    func findPostsWithinXMiles() -> [PFObject] {
        
        var myLocation = appD.retourLocationManager.location
        
        //myLocation.desiredAccuracy = kCLLocationAccuracyBest
        //myLocation.distanceFilter = 50
        
        var query = PFQuery(className: "blogs")
        
        if (reach?.isReachable)! {
            print("can reach - so searching within 50 Miles")
            
            var pfGeoFromCLLocation = PFGeoPoint(location: myLocation)
            
          //  query.whereKey("GMSPlaceGeo", nearGeoPoint: pfGeoFromCLLocation, withinMiles: 1000)
            query.findObjectsInBackground(block: { (object, error) in
                self.resultsToPass = object!
            })
            
        }
        return self.resultsToPass
    }
    
   
    
    
    
}
