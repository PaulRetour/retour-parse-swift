//
//  FirstViewController.swift
//  retour
//
//  Created by Paul Lancashire on 02/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import UIKit
import Parse
import ReachabilitySwift
import CoreLocation
import GoogleMaps
import GooglePlaces

class FirstViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let retourGrey = UIColor(colorLiteralRed: 0.79, green: 0.79, blue: 0.78, alpha: 1.0)

    @IBOutlet weak var baxkgroundImage: UIImageView!
    @IBAction func cancelFromNewPost(sender: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var secondBar: UIView!
    @IBOutlet weak var thirdBar: UIView!
    @IBOutlet weak var fourthBar: UIView!
    
    @IBAction func locationButton(_ sender: Any) {
        if reach.isReachable {
            updateLocation()
        }
    }
    
    // makes sure some view load stuff only runs once //
    var loadedAlready: Bool = false
    
    let reach = Reachability()!

    var placemarks: CLPlacemark!
    var fullPlaceData: [CLPlacemark]?
    
    var locationCoord = CLLocation()
    var geocoder = CLGeocoder()
    var locationString = String()
    
    var locationStringForSearch = ""
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewWillLayoutSubviews() {
        
        let retourGreen = UIColor(red:0.58, green:0.83, blue:0.76, alpha:1.0)

        composeButton.tintColor = retourGreen
        navigationBar.backgroundColor = UIColor.white
        
        if PFUser.current() == nil {
            print("vc - no logged in user")
            performSegue(withIdentifier: "homeToRegisterLoginSegue", sender: self)
        }
        super.viewWillLayoutSubviews()
        
        if reach.isReachable {
            print("Reach - internet connection is available - retrieving data")
           // locationLabel.text = "Loading"
            getCollectionViewA()
            getCollectionViewB()
            updateLocation()
            loadedAlready = true
            
            
        } else {
            print("Reach - no internet connection")
            locationLabel.text = "Internet offline - please check"
            loadedAlready = true
        }
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCollectionViewA(){
        print("collectionviewA")
    }
    
    func getCollectionViewB() {
        print("collectionviewB")
        
    }
    
    func getLocation() {
        print("getting location")
    }
    
    func returnLocationString() {
        
        let geo = GMSGeocoder()
        geo.reverseGeocodeCoordinate(locationCoord.coordinate) { (response, error) in
            if error == nil {
                var info = response?.firstResult()?.locality
                print("info - \(info)")
                DispatchQueue.main.async {
                    self.locationLabel.text = info
                    print("locationlabel text = \(self.locationLabel.text)")
                }
            }
        }
    }
    
    //  func updateLocation( _ completion:() -> Void ) {
    func updateLocation() {
        
        print("Main Home - Updating Location")
        
        let loadingAppD = UIApplication.shared.delegate as! AppDelegate
        if let loccoord = loadingAppD.retourLocationManager.location {
            self.locationCoord = loccoord
            returnLocationString()
        }
    }

}

