//
//  NewPostController.swift
//  retour
//
//  Created by Paul Lancashire on 08/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import Presentr
import ReachabilitySwift
import Parse

class NewPostController: UIViewController, GMSMapViewDelegate, PresentrDelegate, UISearchBarDelegate, GMSAutocompleteResultsViewControllerDelegate, UISearchControllerDelegate {
    
    @IBOutlet var activityIndicator: InstagramActivityIndicator!
    
    let retourGreen = UIColor(red:0.58, green:0.82, blue:0.76, alpha:1.0)    
    let appD = UIApplication.shared.delegate as! AppDelegate
    var reach = Reachability()!
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var location2d = CLLocationCoordinate2D()
    @IBOutlet weak var newPostMap: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    let presenter = Presentr(presentationType: .bottomHalf)
    let presentOfflineError = Presentr(presentationType: .alert)
    
    var alert1VC = UIViewController()

    var popUpVC = NewPostSelectPopUp()
    
//    var mainNav = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: 44))
     var mainNav = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView? 
    
    var place1Image: UIImage!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.lineWidth = 2
        activityIndicator.strokeColor = UIColor.white

        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "RetourMapStyle", withExtension: "json") {
                newPostMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        super.viewDidLoad()
        self.view.addSubview(mainNav)
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
      //  resultsViewController?.view.frame = (CGRect.(x: 0, y: 30, width: UIScreen.main.bounds.width, height: 400)\
        resultsViewController?.view.frame = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: 400)

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.showsCancelButton = true
        searchController?.searchBar.delegate = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: 44)
        mainNav.backgroundColor = retourGreen
        mainNav.addSubview((searchController?.searchBar)!)
        
        
        locManager.delegate = appD
        newPostMap.delegate = self
        placesClient = GMSPlacesClient.shared()
        
        //addNavBar()
        
    }
    
    func cancel() {
        print("cancel")
        self.performSegue(withIdentifier: "cancelFromNewPostWithSender", sender: self)
    }
    
    func displaySearchBar() {

        print("searchbar here")

    }
    
    func removeNavBar() {
       // self.mainNav.isHidden = true
    }
    
    func addNavBar() {
      //  self.mainNav.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        if reach.isReachable {
            getMyLocation()
        } else {
            print("offline - need to add a pop up here or bar text")
            presentNetworkAlertPopUp()
        }
    }
    
    func presentNetworkAlertPopUp() {
        alert1VC = self.storyboard?.instantiateViewController(withIdentifier: "alert1VC") as! Alert1ViewController
        presentOfflineError.dismissOnTap = true
        self.customPresentViewController(presentOfflineError, viewController: alert1VC, animated: true) {
            print("alert presented")
            print(self.alert1VC.view.frame)
            print(self.alert1VC.view.subviews)
            print(self.alert1VC.view.backgroundColor)
        }
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    // Custom Functions - portable
    
    
    // Takes the location ID retrieves again and adds text to popup view
    func presentPopUpView(placeID: String) {
      //  mainNav.isHidden = true
        print("presentpopupview")
        var placeName1: String!
        var placeAddress: String!
        var placeCoord: CLLocationCoordinate2D!
        var placeTypes = [String]()

        placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) in
            print("place name = \(place?.name)")
            print("placeID = \(place?.placeID)")
            placeName1 = place?.name
            placeAddress = place?.formattedAddress
            placeCoord = place?.coordinate
            placeTypes = (place?.types)!
        })
        placesClient.lookUpPhotos(forPlaceID: placeID) { (photoMetaList, error) in
            if error == nil {
                let firstPhotoData = photoMetaList?.results.first
                if firstPhotoData != nil {
               self.loadImageFromMetaData(photoMeta: firstPhotoData!)
                }
            }
        }
        presenter.blurBackground = false
        presenter.backgroundOpacity = 0.1
        
        popUpVC = self.storyboard?.instantiateViewController(withIdentifier: "NewPostSelectPopUp") as! NewPostSelectPopUp
        popUpVC.view.backgroundColor = UIColor.white
        customPresentViewController(presenter, viewController:
        popUpVC, animated: true) {
            print("place name = \(placeName1)")
            self.popUpVC.placeName = placeName1
            self.popUpVC.placeAddress = placeAddress
            self.popUpVC.placeID = placeID
            self.popUpVC.placeCoord = placeCoord
            self.popUpVC.placeTypes = placeTypes
        }
        
    }
    
    func loadImageFromMetaData(photoMeta: GMSPlacePhotoMetadata){
        var outputImage = UIImage()
        self.placesClient.loadPlacePhoto(photoMeta, callback: { (image, error) in
                if error == nil {
                    outputImage = image!
                    print("output image ok")
                    self.popUpVC.image1View.image = image!
                } else {
                    print("issue with output image")
                    outputImage = UIImage(named: "retourlogo")! }
             })
    }
    
    // Takes location, checks for network, returns the location camera
    func createCamera(loc: CLLocationCoordinate2D) -> GMSCameraPosition {
        print("current location = \(loc)")
        
        let cam = GMSCameraPosition.camera(withTarget: loc, zoom: 15)
        
        if reach.isReachable {
            
        }
        return cam
    }
    
    
    // retrieves current location from locmanager
    // gets a current place list
    func getMyLocation() {
    
    locManager.desiredAccuracy = kCLLocationAccuracyBest
    locManager.distanceFilter = 50
    var myLocation = appD.retourLocationManager.location
        print("myLocation = \(myLocation)")
        
        self.activityIndicator.isHidden = false

        placesClient.currentPlace { (likelihoodlist, erro) in
            if erro == nil {
                self.activityIndicator.isHidden = true
                let like = likelihoodlist?.likelihoods[0]
                var loc2d = myLocation?.coordinate
                let place = like?.place
                let placeCoord: CLLocationCoordinate2D! = place?.coordinate
                print("place = \(place)")
                print("place id = \(place!.placeID)")
                self.addCurrentLocationMarker(currentLoc: (place?.coordinate)!, place: (place?.placeID)!)
                self.presentPopUpView(placeID: place!.placeID)

            } else {
                self.activityIndicator.isHidden = true
                print("error") }
        }
    }
    
    func moveCameraToMarker(coordinates: CLLocationCoordinate2D, placeID: String) {
        let newCamera = self.createCamera(loc: coordinates)
        self.newPostMap.camera = newCamera
    }
    
    func addCurrentLocationMarker(currentLoc: CLLocationCoordinate2D, place: String) {
        newPostMap.clear()
        let currentLocMarker = GMSMarker(position: currentLoc)
        currentLocMarker.icon = UIImage(named: "newticketlogo44")
        currentLocMarker.title = "Current Location"
        currentLocMarker.map = self.newPostMap
        currentLocMarker.userData = place
        self.moveCameraToMarker(coordinates: currentLoc, placeID: place)
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker")
        print(marker)
        print("user data \(marker.userData)")
        presentPopUpView(placeID: marker.userData as! String)
        return true
    }
 
    override func willMove(toParentViewController parent: UIViewController?) {
        print("willmove")
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        print("didmove")
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        print("show")
        print(vc)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.popUpVC.dismiss(animated: true, completion: nil)
        print("being dismissed")
        self.view.reloadInputViews()
    }
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        print("presentr dismiss")
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(searchBar.text)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("text")

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("search bar cancel clicked")

        self.performSegue(withIdentifier: "cancelFromNewPostWithSender", sender: self)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        resultsViewController?.dismiss(animated: true) {
            print("was cancelled")
        }
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        print("request predictions")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        print("updating")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = true
        print("results1")
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        print("place id \(place.placeID)")
        resultsController.dismiss(animated: true) {
            print("looking up place id")
            self.placesClient.lookUpPlaceID(place.placeID, callback: { (place, error) in
                if error == nil {
                self.addCurrentLocationMarker(currentLoc: (place?.coordinate)!, place: (place?.placeID)!)
                
                }
                
            })
            
        }
    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        print("end editing")
        return true
    }
}


