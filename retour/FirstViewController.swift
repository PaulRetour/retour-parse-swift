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
import Presentr

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var countryCityImageDataArray: [UIImage]!
    var countryCityTextDataArray: [String]!
    var countryCityIDDataArray: [String]!
    
    // declare individual dictionary type
    // declares an array of dictionaries - string, any type.
    // 3 dictonaries per array - image, location, GMSID //

    var ccDict = [Dictionary<String, Any>]()
    
    let googleSearches = GoogleSearches()
    
    @IBOutlet var noBlogsLabel: UILabel!
    // Place Views Outlets //
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var cityImage: UIImageView!
    @IBOutlet var countryImage: UIImageView!
    
    @IBOutlet var cityReviewLabel: UILabel!
    @IBOutlet var userButton: UIBarButtonItem!
    var cityLookupInt = 0
    var countryLookupInt = 0
    
    let blogPresentr = Presentr(presentationType: .fullScreen)
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let retourGrey = UIColor(colorLiteralRed: 0.79, green: 0.79, blue: 0.78, alpha: 1.0)
    
    var firstCVObjects = [PFObject]()

    @IBOutlet var firstCollectionView: UICollectionView!
    
    let standard = standards()
    
    @IBOutlet var loadingIndicator: InstagramActivityIndicator!
    @IBOutlet weak var baxkgroundImage: UIImageView!
    @IBAction func cancelFromNewPost(sender: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var secondBar: UIView!
    @IBOutlet weak var thirdBar: UIView!

    
    @IBAction func locationButton(_ sender: Any) {
        if reach.isReachable {
            cityLookupInt = 0
            updateLocation()
        }
    }
    
    var nearPosts = [PFObject]() {
        didSet {
            print("didset")
        }
    }
    
    // makes sure some view load stuff only runs once //
    var loadedAlready: Bool = false
    
    let reach = Reachability()!

    var placemarks: CLPlacemark!
    var fullPlaceData: [CLPlacemark]?
    
    
    
    var city: String! {
        didSet {
            // pull the data and update the collection view
            
        }
    }
    
    
    var country: String! {
        didSet {
            // pull the data and update the collection view
            if country != nil && city != nil {
                citySearch = (city+" "+country)
                
            }
        }
    }
    
    var citySearch: String! {
        didSet {
            print("citysearchdidset")
            if cityLookupInt == 0 {
                print("citylookup = 0")
            let gmscoordbounds = GMSCoordinateBounds(coordinate: locationCoord.coordinate, coordinate: locationCoord.coordinate)
                
            // now do a lookup for citySearch and country place ID's
            GMSPlacesClient.shared().autocompleteQuery(citySearch, bounds: gmscoordbounds, filter: nil) { (response, error) in
                if error == nil {
                print("no error search autocomplete citysearch")
                print(response)
                //print(response)
                let cityID: String!
                cityID = response?.first?.placeID
                print("city id = \(cityID)")
                // setup view for city info
                if cityID != nil {
                self.getAndSetCityView(cityIDString: cityID)
                }
                } else {print(error?.localizedDescription)
                print(error)}
            }
            GMSPlacesClient.shared().autocompleteQuery(country, bounds: gmscoordbounds, filter: nil) { (countryResponse, error) in
                if error == nil {
                    print("no country error")
                    let countryID: String!
                    countryID = countryResponse?.first?.placeID
                    print("countryID = \(countryID)")
                    // setup view for country info
                    self.getAndSetCountryView(countryIDString: countryID)
                    self.cityLookupInt = 1
                }
            }
        }
        }

    }

    
    var locationCoord = CLLocation() {
        didSet {
            getPostsNearby()
        }
    }
    var geocoder = CLGeocoder()
    var locationString = String()
    
    var locationStringForSearch = ""
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewWillLayoutSubviews() {
        
        loadingIndicator.isHidden = true
        loadingIndicator.strokeColor = standard.retourGrey
        
        
        let retourGreen = UIColor(red:0.58, green:0.83, blue:0.76, alpha:1.0)

        composeButton.tintColor = retourGreen
        navigationBar.backgroundColor = UIColor.white
        
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        titleImageView.image = UIImage(named: "newticketlogo44.png")
        titleImageView.contentMode = .scaleToFill
        navigationItem.titleView = titleImageView
        self.navigationBar.topItem?.titleView = titleImageView
            
        if PFUser.current() == nil {
            print("vc - no logged in user")
            performSegue(withIdentifier: "homeToRegisterLoginSegue", sender: self)
        }
        super.viewWillLayoutSubviews()
        
        if reach.isReachable && PFUser.current() != nil {
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
        
        noBlogsLabel.isHidden = true
        
        firstCollectionView.delegate = self
        firstCollectionView.dataSource = self
        
        //cityImage.layer.cornerRadius = (cityImage.bounds.height / 2)
       // countryImage.layer.cornerRadius = (countryImage.bounds.height / 2)
        cityImage.clipsToBounds = true
        countryImage.clipsToBounds = true
        
        self.firstCollectionView.register(UINib(nibName: "MainHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainHomeCollectionViewCell")

        super.viewDidLoad()
       // getAllMyPosts()
        
        userButton.tintColor = standard.retourGreen

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
        print("attempting location string")
        // stick a spinner here... close it when the error == nil //
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        let geo = GMSGeocoder()
        geo.reverseGeocodeCoordinate(locationCoord.coordinate) { (response, error) in
            if error == nil {
                self.loadingIndicator.isHidden = true
                self.loadingIndicator.stopAnimating()
                var info = response?.firstResult()?.locality
                print("info - \(info)")
                DispatchQueue.main.async {
                    self.locationLabel.text = info
                    self.city = response?.firstResult()?.locality
                    self.country = response?.firstResult()?.country
                    print("locationlabel text = \(self.locationLabel.text)")
                }
                // Get Some Default Images //
            } else {print("location label error \(error?.localizedDescription)")}
        }
    }
    

    
    //  func updateLocation( _ completion:() -> Void ) {
    func updateLocation() {
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        print("Main Home - Updating Location")
        if reach.isReachable {
        let loadingAppD = UIApplication.shared.delegate as! AppDelegate
        if let loccoord = loadingAppD.retourLocationManager.location {
            self.loadingIndicator.isHidden = true
            self.locationCoord = loccoord
            returnLocationString()
        }
        } else { locationLabel.text = "Offline" }
    }

    // test function to get all posts not by me!
    func getAllMyPosts() {
        var query = PFQuery(className: "blogs")
        query.includeKey("userPoint")
        query.addDescendingOrder("createdAt")
       // query.whereKey("userPoint", notEqualTo: PFUser.current())
        query.findObjectsInBackground { (object, error) in
            if error == nil {
              print("data")
                print(object)
                self.nearPosts = object!
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("home view did appear")
        if PFUser.current() == nil {
            performSegue(withIdentifier: "homeToRegisterLoginSegue", sender: self)
        } else {
            print("reloading input view")
            if reach.isReachable && PFUser.current() != nil {
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
    }
    
    func getPostsNearby() {
        noBlogsLabel.isHidden = true
        print("getPostsNearby")
        var query = PFQuery(className: "blogs")
        query.includeKey("userPoint")
        query.addDescendingOrder("createdAt")
     //   query.whereKey("image0file", notEqualTo: "")
        query.whereKeyExists("image0file")
        if reach.isReachable {
            returnLocationString()
            let loc = PFGeoPoint(latitude: locationCoord.coordinate.latitude, longitude: locationCoord.coordinate.longitude)
            query.whereKey("GMSPlaceGeo", nearGeoPoint: loc, withinMiles: 100)
           // query.whereKey("image0file", notEqualTo: "")
            query.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    if objects!.count > 0 {
    
                // update cllocation view here //
                print(objects)
                self.firstCVObjects = objects!
                self.firstCollectionView.reloadData()
                    } else {
                        print("no blogs to display")
                        self.noBlogsLabel.isHidden = false
                    }
                    
                } else {
                    print("error")
                }
            })
        }
    }
    
    func getAndSetCityView(cityIDString: String) {
        print("getandsetcityview")
        GMSPlacesClient.shared().lookUpPlaceID(cityIDString) { (cityPlaceResponse, error) in
            if error == nil {
                print("getting city data")
                print(cityPlaceResponse)
                self.cityLabel.text = cityPlaceResponse?.name
                GMSPlacesClient.shared().lookUpPhotos(forPlaceID: cityIDString, callback: { (cityImageCallback, error) in
                    if error == nil {
                        if let firstCityPhoto = cityImageCallback?.results.first {
                            self.loadCityImageForMetadata(photoMetadata: firstCityPhoto)
                            var indDict : NSMutableDictionary = [String : Any]() as! NSMutableDictionary
                            indDict = ["Image" : firstCityPhoto, "PlaceName" : cityPlaceResponse?.name, "PlaceID" : cityIDString]
                            
                            print("inddict = \(indDict)")
                            self.ccDict.append(indDict as! Dictionary<String, Any>)
                            print("ccdict = \(self.ccDict)")
                            print("ccdict count = \(self.ccDict.count)")
                        }
                    }
                })
            }
        }
    }
    
    func loadCityImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata) { (image, error) in
            if error == nil {
                self.cityImage.image = image
            }
        }
    }
    
    func getAndSetCountryView(countryIDString: String!) {
        print("getandsetcountryview")
        GMSPlacesClient.shared().lookUpPlaceID(countryIDString) { (countryPlaceResponse, error) in
            if error == nil {
                print("getting country data")
                print(countryPlaceResponse)
                self.countryLabel.text = countryPlaceResponse?.name
                GMSPlacesClient.shared().lookUpPhotos(forPlaceID: countryIDString, callback: { (countryImageCallback, error) in
                    if error == nil {
                        if let firstCountryPhoto = countryImageCallback?.results.first {
                            
                            self.loadCountryImageForMetadata(photoMetadata: firstCountryPhoto)
                        }
                    }
                })
            }
        }
    }
    
    func loadCountryImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata) { (image, error) in
            if error == nil {
                self.countryImage.image = image
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return firstCVObjects.count
        print(firstCVObjects.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == firstCollectionView {
        let cellData = firstCVObjects[indexPath.row] as! PFObject
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainHomeCollectionViewCell", for: indexPath) as! MainHomeCollectionViewCell
        
        cellData.fetchIfNeededInBackground { (response, error) in
            if error == nil {
                cell.cellUserLabel.text = cellData.value(forKey: "username2") as? String
            } else { print("error \(error)") }
        }
        
        cell.cellLocationLabel.text = cellData.value(forKey: "GMSPlaceQuickName") as! String
        

        
            let image = cellData.value(forKey: "image0file") as! PFFile
            image.getDataInBackground(block: { (finaldata, error) in
                if error == nil {
                    let finalImage: UIImage = UIImage(data: finaldata!)!
                    cell.mainImage.image = finalImage
                }
            })
            return cell
        } else {
            let cell = UICollectionViewCell()
            return cell
        }

        }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected image")
        print("first cv objects -\(firstCVObjects[indexPath.row] as! PFObject)")
        
        let selectedData = firstCVObjects[indexPath.row] as! PFObject
        let blogView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
        blogView.incomingData = selectedData
        print("sent data")
        customPresentViewController(blogPresentr, viewController: blogView, animated: true) {
            print("presented view")
        }
        
    }
    
    func populateCityCountryArray(image: UIImage, collectionViewID: UICollectionView) {
        if countryCityImageDataArray.count > 0 {
            
            // add the image and reload the collection view
            countryCityImageDataArray.append(image)
            collectionViewID.reloadData()
            
        }
    }
    
    func updateCollectionView(array: Array<Any>) {
        
    }
}

