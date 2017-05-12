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

class NewPostController: UIViewController, GMSMapViewDelegate, PresentrDelegate, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate, GMSAutocompleteResultsViewControllerDelegate {
    
    let retourGreen = UIColor(red:0.58, green:0.83, blue:0.76, alpha:1.0)
    
    let appD = UIApplication.shared.delegate as! AppDelegate
    var reach = Reachability()!
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var location2d = CLLocationCoordinate2D()
    @IBOutlet weak var newPostMap: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    let presenter = Presentr(presentationType: .bottomHalf)
    var popUpVC = NewPostSelectPopUp()
    
    var mainNav = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
  //  var mySearchBar = UISearchBar(frame:  CGRect(x: 10, y: 0, width: (UIScreen.main.bounds.width - 10), height: 44))
    
    var searchButton = UIButton(type: UIButtonType.system)
    var cancelButton = UIButton(type: UIButtonType.system)
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    var objectToSave: PFObject?
    
    func cancel() {
        print("cancel")
        self.performSegue(withIdentifier: "cancelFromNewPostWithSender", sender: self)
    }
    
    func displaySearchBar() {
        print("searchbar here")
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        self.mainNav.addSubview((searchController?.searchBar)!
        )
     //   navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    func removeNavBar() {
        self.mainNav.removeFromSuperview()
    }
    
    func addNavBar() {
        print("adding nav bar")
        self.view.addSubview(mainNav)
        mainNav.backgroundColor = retourGreen
        searchButton.frame = CGRect(x: (UIScreen.main.bounds.width - 70), y: 5, width: 60, height: 40)
        cancelButton.frame = CGRect(x: 5, y: 5, width: 60, height: 40)
        searchButton.tintColor = UIColor.white
        cancelButton.tintColor = UIColor.white
        searchButton.setTitle("Search", for: UIControlState.normal)
        cancelButton.setTitle("Cancel", for: UIControlState.normal)
        searchButton.addTarget(self, action: #selector(displaySearchBar), for: UIControlEvents.touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
        self.mainNav.addSubview(searchButton)
        self.mainNav.addSubview(cancelButton)
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBar()
        locManager.delegate = appD
        newPostMap.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if reach.isReachable {
            getMyLocation()
        } else {
            print("offline - need to add a pop up here or bar text")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Custom Functions - portable
    
    
    // Takes the location ID retrieves again and adds text to popup view
    func presentPopUpView(placeID: String) {

        print("presentpopupview")
        var placeName1: String!
        var placeAddress: String!
        placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) in
            print("place name = \(place?.name)")
            print("placeID = \(place?.placeID)")
            placeName1 = place?.name
            placeAddress = place?.formattedAddress
        })
        placesClient.lookUpPhotos(forPlaceID: placeID) { (photoMetaList, error) in
            if error == nil {
                let firstPhotoData = photoMetaList?.results.first
                se
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
        }
        
    }
    
    func loadImageFromMetaData(photoMeta: GMSPlacePhotoMetadata) {
        placesClient.loadPlacePhoto(photoMeta) { (image, error) in
            if error == nil {
                
            }
        }
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

        placesClient.currentPlace { (likelihoodlist, erro) in
            if erro == nil {
                let like = likelihoodlist?.likelihoods[0]
                var loc2d = myLocation?.coordinate
                let place = like?.place
                let placeCoord: CLLocationCoordinate2D! = place?.coordinate
                print("place = \(place)")
                print("place id = \(place!.placeID)")
                self.addCurrentLocationMarker(currentLoc: (place?.coordinate)!, place: (place?.placeID)!)
                self.presentPopUpView(placeID: place!.placeID)

            } else { print("error") }
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

    func prepareObjectForSegue(location: CLLocationCoordinate2D, placeID: String, coord: CLLocationCoordinate2D) {
        objectToSave?.add(placeID, forKey: "GMSPlaceID")
        objectToSave?.add(coord, forKey: "GMSPlaceGeo")
        performSegue(withIdentifier: "goToMedisAddSegue", sender: self)
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
        addNavBar()
    }
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        print("presentr dismiss")
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("text")
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self as! GMSAutocompleteViewControllerDelegate
        autocompleteController.tintColor = retourGreen
        present(autocompleteController, animated: true) { 
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      //  self.mainNav.removeFromSuperview()
      //  addNavBar()
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        print("place id \(place.placeID)")
        resultsController.dismiss(animated: true) {
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
    
}


