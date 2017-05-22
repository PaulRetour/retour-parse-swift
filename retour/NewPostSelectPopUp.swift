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
import GooglePlaces
import Parse

class NewPostSelectPopUp: UIViewController  {
    
    var objectToSave = PFObject(className: "blogs")
    let nextVCpresentr = Presentr(presentationType: .fullScreen)
    var fullPostVC = FullPostController()
    var placeID: String!
    var placeCoord: CLLocationCoordinate2D!

    var placeName: String! {
        didSet {
            placeNameLabel.text = placeName
            if placeNameLabel.text != nil {
            print("unhiding button")
            nextButtonOutlet.isHidden = false
            }
        }
    }
    
    @IBOutlet weak var nextButtonOutlet: UIButton!

    
    
    var placeAddress: String! {
        didSet {
            addressLabel.text = placeAddress
        }
    }
    
    var image1: UIImage! {
        didSet {
            print("image1 updated")
            updateImages()
        }
    }
    
    func updateImages() {
        print("updating images")
        
    }
    
    var reach = Reachability()!
    
    @IBAction func nextButton(_ sender: Any) {
        prepareObjectForSegue(location: placeCoord, placeID: placeID)
    }
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var image1View: UIImageView!
    
    override func viewDidLoad() {
        nextButtonOutlet.isHidden = true
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOpacity = 0.5
        self.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.view.layer.shadowRadius = 15
        self.view.backgroundColor = UIColor.clear
        if placeName != nil {
        print("popup placename = \(placeName)")
        }
        
    }

    
    func prepareObjectForSegue(location: CLLocationCoordinate2D, placeID: String) {
        print("prepare to segue!")
        fullPostVC = self.storyboard?.instantiateViewController(withIdentifier: "FullPostController") as! FullPostController


        nextVCpresentr.transitionType = TransitionType.coverHorizontalFromRight
        customPresentViewController(nextVCpresentr, viewController: fullPostVC, animated: true) { 
            print("presented")
            self.objectToSave.add(placeID, forKey: "GMSPlaceID")
            self.objectToSave.add(location, forKey: "GMSPlaceGeo")
            print("placename = \(self.placeName)")
            print("placeaddress = \(self.placeAddress)")
            self.fullPostVC.placeNameLabel.text = self.placeName
            self.fullPostVC.placeAddressLabel.text = self.placeAddress
            self.fullPostVC.objectToSave = self.objectToSave
        }
    }

}
