//
//  SecondViewController.swift
//  retour
//
//  Created by Paul Lancashire on 02/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//
// Temp Map View

import UIKit
import GoogleMaps
import GooglePlaces
import Presentr
import Foundation
import Parse
import ReachabilitySwift
import FBSDKCoreKit

class SecondViewController: UIViewController, GMSMapViewDelegate, UICollectionViewDelegate {
    
    let GoogleSearch = GoogleSearches()
    
    let cg1 = CGSize(width: 1, height: 1)
    

    
    var filterID = 0
    
    @IBOutlet var navBar: UINavigationBar!
    
    var finalBounds = GMSCoordinateBounds()
    
    @IBOutlet var prefsButtonOutlet: UIBarButtonItem!
    
    let retourStandards = standards()
    
    @IBOutlet var searchInfoLabel: UILabel!
    var unwindPrefsString: String!
    
    var defaults = UserDefaults.standard
    var queries = Queries()
    var response = [PFObject]()
    var useProfilePrefs: Bool?
    
    var lookupID: String!
    
    var singlePointResults = [PFObject]() //
    var markerObjects = [PFObject]() // for when tapping on the marker - filters out all but marker objects
    
    var reach = Reachability()!
    
    var myGeoPointLocation = PFGeoPoint(latitude: 00.00, longitude: 00.00)
    
    var markerInfo = [CLLocationCoordinate2D]()
    
    let ageRangeCalc = AgeRangeCalculator()
    
    override func viewDidAppear(_ animated: Bool) {
        if appD.retourLocationManager.location != nil {
        myGeoPointLocation.latitude = (appD.retourLocationManager.location?.coordinate.latitude)!
        myGeoPointLocation.longitude = (appD.retourLocationManager.location?.coordinate.longitude)!
            
        mapCameraToMyLocation(location: (appD.retourLocationManager.location?.coordinate)!)
        }
    }
    
    //var myLocationPin = MKMapItem.mapItemForCurrentLocation()
    var locationPinSet = false  //  If set, then user has long clicked.  factor this into the search //
    var locationPinSetCoords = CLLocationCoordinate2D()
    
    // Search Parameters - From NSUserDefaults  //
    
    // Search Time Intervals

    var dayInterval = Date(timeIntervalSinceNow: -60*60*24)
    var twoDayInternal = Date(timeIntervalSinceNow: -60*60*24*2)
    var weekInterval = Date(timeIntervalSinceNow: -60*60*24*7)
    var monthInterval = Date(timeIntervalSinceNow: -60*60*24*30)
    
    var searchUserDefaults = UserDefaults.standard
    var searchDistance: Double = 50
    var searchStatus = ""
    var timeFrameString = String()
    
    // used to decide correct cell - essential  //
    var imageCount: Int = 0
    
    
    //  PFUser and Blog Object Variables    //
    var myUserID = PFUser.current()?.objectId
    var allPostsQuery = PFQuery(className: "blogs")
    var objects = [PFObject]()
    var results = [PFObject]()
    var user: AnyObject!
    var blogentry = [PFObject]()

    // Use viewwillappear to reload data //
    override func viewWillAppear(_ animated: Bool) {
        mapView.isMyLocationEnabled = true
        print("view appear")
       // getUsBlogs2()
       // getBlogsUsingPrefs()
    }
    
    let appD = UIApplication.shared.delegate as! AppDelegate
    var locManager = CLLocationManager()
    var currentLocation: CLLocation! {
        didSet {
            myGeoPointLocation.latitude = currentLocation.coordinate.latitude
            myGeoPointLocation.longitude = currentLocation.coordinate.longitude
        }
    }

    var location2d = CLLocationCoordinate2D()

    var searchText = String()
    var toFilter = false
    
    let presenter = Presentr(presentationType: .bottomHalf)
    
    
  //  let customerLowerPresenter = Presentr(
    let lowerCustomType = PresentationType.custom(width: ModalSize.full, height: ModalSize.custom(size: 200), center: ModalCenterPosition.custom(centerPoint: CGPoint(x: (UIScreen.main.bounds.width / 2), y: (UIScreen.main.bounds.height - 200))))
    
    var prefsPresentr = Presentr(presentationType: .fullScreen)
    
    var prefsVC = UIViewController()
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBAction func prefsButton(_ sender: Any) {
        
        customPresentViewController(prefsPresentr, viewController:
            prefsVC, animated: true) { 
                
        }

    }
    
    func getBlogs() {
        var myLocation = appD.retourLocationManager.location
        var query = PFQuery(className: "blogs")
        query.findObjectsInBackground(block: { (object, error) in
            if error == nil {
                self.response = object!
                print(self.response)
            }
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // defaults.setValue("", forKey: "searchText")
        defaults.removeObject(forKey: "searchText")
        navBar.backgroundColor = UIColor.white


        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "RetourMapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        
       // prefsPresentr.presentationType = .fullScreen
        prefsPresentr.transitionType = .coverHorizontalFromRight
//        prefsPresentr.presentationType = .custom(width: ModalSize.full, height: ModalSize.full, center: ModalCenterPosition.custom(centerPoint: CGPoint(x: 200, y: 0)))
//        prefsPresentr.backgroundColor = UIColor.white
//        prefsPresentr.backgroundOpacity = 0.5
        
        prefsVC = (self.storyboard?.instantiateViewController(withIdentifier: "PrefsViewController"))!
        presenter.backgroundOpacity = 0.5
        presenter.backgroundColor = UIColor.white
        
        let shad = PresentrShadow(shadowColor: UIColor.black, shadowOpacity: 0.4, shadowOffset: cg1 ,shadowRadius: 1)
        presenter.dropShadow = shad
        
        presenter.presentationType = .custom(width: ModalSize.full, height: ModalSize.custom(size: 200), center: ModalCenterPosition.custom(centerPoint: CGPoint(x: (UIScreen.main.bounds.width/2), y: (UIScreen.main.bounds.height - 100 ))))
       // presenter.blurBackground = true
        
        
        mapView.backgroundColor = UIColor.white
        
        mapView.delegate = self
        
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        titleImageView.image = UIImage(named: "newticketlogo44.png")
     //   titleImageView.image = UIImage(named: "stripeIcon48.png")
        titleImageView.contentMode = .scaleToFill
        self.navBar.topItem?.titleView = titleImageView
        
        prefsButtonOutlet.tintColor = retourStandards.retourGreen
        
       // getUsBlogs2()
      //  getBlogsUsingPrefs()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindCancelFromPrefs(sender: UIStoryboardSegue) {
        print("unwind")
        print("dont' do anything else!")
    }
    
    
    @IBAction func unwindSaveFromPrefs(sender: UIStoryboardSegue) {
        print("unwind and save")
        print("receive data and perform search - update view")
        
        searchInfoLabel.text = "testing ok?"

        if defaults.value(forKey: "searchText") != nil {
            searchText = defaults.value(forKey: "searchText") as! String
            print("search text to predicate = \(searchText)")
        }
        
      //  queries.findAllPosts(searchString: "test")
       // getUsBlogs2()
        
        if defaults.value(forKey: "defaultsSwitch") as! Bool == true {
            print("auto on so auto on search")
            getBlogsAutoOn()
        } else {
            print("auto off so auto off search")
            getBlogsAutoOff()
        }
        

    }
    
    // If auto setting is on, get all data from user profile - distance and time from prefs.
    // MUST calculate an age range for the query
    func getBlogsAutoOn() {
        
        // update location
        if appD.retourLocationManager.location != nil {
            myGeoPointLocation.latitude = (appD.retourLocationManager.location?.coordinate.latitude)!
            myGeoPointLocation.longitude = (appD.retourLocationManager.location?.coordinate.longitude)!
            print("current location for search - \(myGeoPointLocation)")
        }
        
        var autoOnQuery = PFQuery(className: "blogs")
        var userQuery = PFUser.query()
        
        // Birthdate Range Finder
        let userBirthday = PFUser.current()?.value(forKey: "birthday") as! String
        var format = DateFormatter()
        format.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        var dateToUse = userBirthday 
        let ageRangeInt: Int = ageRangeCalc.returnAgeRangeInt(userBirthdayParseString: dateToUse)
        print("Auto On Date Range = \(ageRangeInt)")
        
        
        // Get Upper and Lower Date for Query
        var blogUserDate = DateFormatter()
        blogUserDate.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        var blogUserTimeInterval = TimeInterval()
        let lowerDate = ageRangeCalc.returnLowerInterval(int: ageRangeInt) as! Date
        let upperDate = ageRangeCalc.returnUpperInterval(int: ageRangeInt) as! Date
        print("Query lowerdate = \(lowerDate)")
        print("Query upperdate = \(upperDate)")

        // Retrieve Status for Auto Query
        let userStatus = PFUser.current()?.value(forKey: "status") as! String
        print("Query Status = \(userStatus)")
        
        // Get Search Max Distance from Prefs
        let searchDistance = searchUserDefaults.double(forKey: "searchDistance")
        print("autoOnDistance = \(searchDistance)")
        
        // Get Timeframe for Auto Search
        let timeFrame = searchUserDefaults.value(forKey: "timeframe") as! String
        var searchEarliest = Date()
        switch timeFrame {
        case "day" :
            searchEarliest = dayInterval
        case "twodays" :
            searchEarliest = twoDayInternal
        case "week" :
            searchEarliest = weekInterval
        case "month" :
            searchEarliest = monthInterval
        default :
            searchEarliest = dayInterval
        }
        
        
        // BUILD THE QUERY //
        
        // add max distance to query
        autoOnQuery.whereKey("GMSPlaceGeo", nearGeoPoint: myGeoPointLocation, withinMiles: self.searchDistance)
        // add blog creation date
        autoOnQuery.whereKey("createdAt", greaterThanOrEqualTo: searchEarliest)
        // add status query to match
        userQuery?.whereKey("status", equalTo: userStatus)

        // add age range..
        
        // connect the queries
        autoOnQuery.whereKey("userPoint", matchesQuery: userQuery!)
        
        // Complete the Query
        autoOnQuery.findObjectsInBackground { (objects, error) in
            if error == nil {
                print("objectcount \(objects?.count)")
                print("no error in retrieving autoOnQuery - \(objects)")
                
                // filter if string exists
              //  let filtered: [PFObject] = objects!.filter{ $0.allKeys.contains(self.searchText) }
                if self.toFilter == true {
                print("search text = \(self.searchText)")
                let filtered: [PFObject] = (objects?.filter { ($0.value(forKey: "title") as! String).localizedCaseInsensitiveContains(self.searchText) || ($0.value(forKey: "body") as! String).localizedCaseInsensitiveContains(self.searchText) || ($0.value(forKey: "tags") as! String).localizedCaseInsensitiveContains(self.searchText) })!
                print("filtered array = \(filtered)")
                self.results = filtered
                self.filterID = 1
                }
                if self.filterID == 0 {
                    self.results = objects! }
                self.removeMarkersFromMap() // Clear current markers
                self.addMarkersToMap()
                self.filterID = 0
                
            }
        }
        
    }
    
    // If auto setting is off, get all data from prefs including distance and time.  If ANY, then don't filter.
    func getBlogsAutoOff() {
        
        // update location
        if appD.retourLocationManager.location != nil {
            myGeoPointLocation.latitude = (appD.retourLocationManager.location?.coordinate.latitude)!
            myGeoPointLocation.longitude = (appD.retourLocationManager.location?.coordinate.longitude)!
            print("current location for search - \(myGeoPointLocation)")
        }
        
        var autoOffQuery = PFQuery(className: "blogs")
        var userQuery = PFUser.query()
        //autoOffQuery.includeKey("userPoint")
        
        var ageRangeInt: Int?
        
        // Get Search Max Distance from Prefs
        let searchDistance = defaults.double(forKey: "searchDistance")
        print("autoOffDistance = \(searchDistance)")
        
        // Get Upper and Lower User Date for Query
        let blogUserDate = DateFormatter()
        blogUserDate.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        var blogUserTimeInterval = TimeInterval()

        // Get Status
        let status = PFUser.current()?.object(forKey: "status") as? String
        print("autooffquery - status from current user object = \(status)")
        
        // Get Age Range String
        let ageSearchString = defaults.value(forKey: "ageRange") as? String
        
        // Get the age range int //
        switch ageSearchString! {
        case "Any" :
            print("age search string = any")
            ageRangeInt = 0
        case "sixteenThirty" :
            print("age search string = sixteenThirty")
            ageRangeInt = 1
        case "thirtyOneFortyFive" :
            print("age search string = thirtyOneFortyFive")
            ageRangeInt = 2
        case "fortyFiveSixty" :
            print("age search string = fortyFiveSixty")
            ageRangeInt = 3
        case "sixtyPlus" :
            print("age search string = sixtyPlus")
            ageRangeInt = 4
        default:
            print("no age search string weirdly, so setting to Any")
            ageRangeInt = 0
        }
        
        // If age range != 0 set upper and lower date
        
        if ageRangeInt != 0 {
            print("age range int != 0")
            let lowerDate = ageRangeCalc.returnLowerInterval(int: ageRangeInt!) as Date
            let upperDate = ageRangeCalc.returnUpperInterval(int: ageRangeInt!) as Date
            userQuery?.whereKey("birthDate", lessThan: lowerDate)
            print("query add - birthday less that \(lowerDate)")
            userQuery?.whereKey("birthDate", greaterThan: upperDate)
            print("query add - birthday greater that \(upperDate)")
            
            // Add the reference to the user query here as its going to be used...
            autoOffQuery.whereKey("userPoint", matchesQuery: userQuery!)
            
            
        } else {
        print("age range int == 0 so no additional date queries")}
        
        
        // Get Timeframe for Auto Search
        let timeFrame = searchUserDefaults.value(forKey: "timeframe") as! String
        var searchEarliest = Date()
        switch timeFrame {
        case "day" :
            searchEarliest = dayInterval
        case "twodays" :
            searchEarliest = twoDayInternal
        case "week" :
            searchEarliest = weekInterval
        case "month" :
            searchEarliest = monthInterval
        default :
            searchEarliest = dayInterval
        }
     autoOffQuery.whereKey("createdAt", greaterThanOrEqualTo: searchEarliest)

        
        // Status query dependent upon Status setting in prefs
        
        let searchStatus1 = defaults.value(forKey: "status") as! String
        if searchStatus1 != "Any" {
            print("adding status query")
            userQuery?.whereKey("status", equalTo: searchStatus1)
            autoOffQuery.whereKey("userPoint", matchesQuery: userQuery!)

        } else { print("not adding status query") }
        
        
        // add max distance to query
        print("adding distance of within \(self.searchDistance)")
        autoOffQuery.whereKey("GMSPlaceGeo", nearGeoPoint: myGeoPointLocation, withinMiles: self.searchDistance)
    
        // complete the queries
        autoOffQuery.findObjectsInBackground { (objects, error) in
            print("start of autooffquery")
            if error == nil {
                print("objectcount \(objects?.count)")
                print("no error in retrieving autoOffQuery - \(objects)")

                if self.toFilter == true {
                    print("search text = \(self.searchText)")
                    let filtered: [PFObject] = (objects?.filter { ($0.value(forKey: "title") as! String).localizedCaseInsensitiveContains(self.searchText) || ($0.value(forKey: "body") as! String).localizedCaseInsensitiveContains(self.searchText) || ($0.value(forKey: "tags") as! String).localizedCaseInsensitiveContains(self.searchText) })!
                    print("filtered array = \(filtered)")
                    self.results = filtered
                    self.filterID = 1
                }
                if self.filterID == 0 {
                    self.results = objects! }
                self.removeMarkersFromMap() // Clear current markers
                self.addMarkersToMap()
                self.filterID = 0
                
            } else { print(error)}
//            if error == nil {
//                print("objectcount \(objects?.count)")
//                print("no error in retrieving autoOnQuery - \(objects)")
//                self.results = objects!
//                self.removeMarkersFromMap() // Clear current markers
//                self.addMarkersToMap()
//            }
        }
    }
    
    func getUsBlogs2() {
        
        print("QUERY BEGINS HERE")
        print("saved default preferences for reference")
        print("status - \(defaults.value(forKey: "status"))")
        print("age range - \(defaults.value(forKey: "ageRange"))")
        // Variables for Searches
        var status: String?
        var ageRangeInt: Int?
        var userAge: String?
        var lowerDate: Date?
        var upperDate: Date?
        
        var myLocation = appD.retourLocationManager.location
        
        let startCamera = GMSCameraPosition.camera(withTarget: (myLocation?.coordinate)!, zoom: 10)
        mapView.camera = startCamera
        
        // Add the Blog > User Pointer to the query //
        print("query INCLUDE - userPoint")
        allPostsQuery.includeKey("userPoint")
        var userQuery = PFUser.query()

        
        // Get the defaultsSwitch status
        var auto = defaults.bool(forKey: "defaultsSwitch")
        // First, if the defaults switch is on, get the user birthday and status from pfuser
        // Get the age range bracket to find upper and lower NSTimeInterval for User birthdate search
        // This auto bool is to get the right settings from the right location //
        if auto == true {
            print("auto enabled")
            var usertest = PFUser.current()?.object(forKey: "birthday")
            var format = DateFormatter()
            format.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
           // var dateToUse = format.string(from: usertest as! Date )
            var dateToUse = usertest as! String
           // var dateToUse = format.string(from: Date)
            // Get the Age Range Int from the userAge
            ageRangeInt = ageRangeCalc.returnAgeRangeInt(userBirthdayParseString: dateToUse)
            print("logged in user age Range = \(ageRangeInt)")
            // Get the User's status //
            status = PFUser.current()?.object(forKey: "status") as? String
            print("logged in user status = \(status)")
            // Date Conversion Stuff //
            var blogUserDate = DateFormatter()
            blogUserDate.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
            var blogUserTimeInterval = TimeInterval()
            // work out an upper and lower date for the query //
            lowerDate = ageRangeCalc.returnLowerInterval(int: ageRangeInt!) as Date
            upperDate = ageRangeCalc.returnUpperInterval(int: ageRangeInt!) as Date
            print("lowerdate = \(lowerDate)")
            print("upperdate = \(upperDate)")
            
        } else {
            // if not auto enabled, get the preference setting for status and age range
            // status works... need to sort the age range //*******
            print("auto disabled")
            
            if defaults.value(forKey: "ageRange") == nil {
                defaults.setValue("Any", forKey: "ageRange")
            }
            status = defaults.value(forKey: "status") as? String
            print("search status = \(status)")
            print("age range = \(defaults.value(forKey: "ageRange"))")
            var ageSearchString: String?
            ageSearchString = defaults.value(forKey: "ageRange") as? String
            
            // Get the age range int //
            switch ageSearchString! {
            case "Any" :
                print("age search string = any")
                ageRangeInt = 0
            case "sixteenThirty" :
                print("age search string = sixteenThirty")
                ageRangeInt = 1
            case "thirtyOneFortyFive" :
                print("age search string = thirtyOneFortyFive")
                ageRangeInt = 2
            case "fortyFiveSixty" :
                print("age search string = fortyFiveSixty")
                ageRangeInt = 3
            case "sixtyPlus" :
                print("age search string = sixtyPlus")
                ageRangeInt = 4
            default:
                print("no age search string weirdly, so setting to Any")
                ageRangeInt = 0
            }
            
            if ageRangeInt != 0 {
                lowerDate = ageRangeCalc.returnLowerInterval(int: ageRangeInt!) as Date
                upperDate = ageRangeCalc.returnUpperInterval(int: ageRangeInt!) as Date
                print("lowerdate = \(lowerDate)")
                print("upperdate = \(upperDate)")
            } else {
                print("age range int == 0 so not applying any upper and lower dates")
            }
        }
        
        // All settings should now be setup //
        // Now apply them if auto == true //
        // Otherwise, check for Any - if exists, do not apply //
        
        if auto == true {
            // always apply all settings //
            // apply status filter //
            print("userquery - add equal to status")
            userQuery?.whereKey("status", equalTo: status!)
            print("query - match userQuery")
            allPostsQuery.whereKey("userPoint", matchesQuery: userQuery!)
            // apply birthdate range filter //
            print("query add - birthday less than and greater than")
            userQuery?.whereKey("birthday", lessThan: lowerDate!)
            userQuery?.whereKey("birthday", greaterThan: upperDate!)
        } else {
            // check for any against birthdate or status - if not any, apply filter //
            if status != "Any" {
                userQuery?.whereKey("status", equalTo: status!)
                print("query add - status is equal to \(status!)")
            } else {
                print("no status query added as status == any")
            }
           // allPostsQuery.whereKey("userPoint", matchesQuery: userQuery)
          //  allPostsQuery.whereKey("userPoint", matchesQuery: userQuery!)
            
            if ageRangeInt != 0 {
                userQuery?.whereKey("birthday", lessThan: lowerDate!)
                print("query add - birthday less that \(lowerDate)")
                userQuery?.whereKey("birthday", greaterThan: upperDate!)
                print("query add - birthday greater that \(upperDate)")
            } else {
            print("age range = any.. will try deselecting keys in userquery")
            
            }
            
        }
        
        // Always apply the search distance and search time options //
        self.searchDistance = searchUserDefaults.double(forKey: "searchDistance")
        // check for existence of timeframe - if none then set it
        if searchUserDefaults.value(forKey: "timeframe") != nil {
            self.timeFrameString = searchUserDefaults.value(forKey: "timeframe") as! String
        }   else { self.timeFrameString = "day" }
        print("query add - distance = \(searchDistance)")
        print("query add - time frame = \(self.timeFrameString)")
        
        // create a data from prerefences that is the earliest date to search from
        var searchEarliest = Date()
        switch self.timeFrameString {
        case "day" :
            searchEarliest = dayInterval
        case "twodays" :
            searchEarliest = twoDayInternal
        case "week" :
            searchEarliest = weekInterval
        case "month" :
            searchEarliest = monthInterval
        default :
            searchEarliest = dayInterval
        }
        
        //  Apply filter to not show your own blogs! //
        // allPostsQuery.whereKey("createdBy", notEqualTo: self.myUserID!)  // query - all users except caller - needs to update to new pointer field
        
        if locationPinSet == false {
            print("query add - distance within \(self.searchDistance) of \(myGeoPointLocation)")
            allPostsQuery.whereKey("GMSPlaceGeo", nearGeoPoint: myGeoPointLocation, withinMiles: self.searchDistance) // query for entries within searchdistance value
        } else if locationPinSet == true {
            var pinSetGeoPoint = PFGeoPoint(latitude: locationPinSetCoords.latitude, longitude: locationPinSetCoords.longitude)
            allPostsQuery.whereKey("GMSPlaceGeo", nearGeoPoint: pinSetGeoPoint, withinMiles: self.searchDistance)
        }
        
        
        ///
         print("query filter = after \(searchEarliest)")
        allPostsQuery.whereKey("createdAt", greaterThanOrEqualTo: searchEarliest) // query for entries NO OLDER than the searchearliest value
        print("query add - created later than \(searchEarliest)")
        allPostsQuery.order(byDescending: "createdAt")
        allPostsQuery.findObjectsInBackground { (objects, error) -> Void in // Find and then stick into the function below...
            
            print("performing allPostsQuery")
            print(self.allPostsQuery)
            
            if error == nil {
                print("returned objects - \(objects)")
                if let objects = objects as [PFObject]! {
                    self.results = objects
                }
                print("results are \(self.results)")
                
             //   self.usTableView.reloadData()
                print("set markrs here")// once all is done reload the table view and populate
                self.removeMarkersFromMap() // Clear current markers
                self.addMarkersToMap() // also add the markers to the Map View - Need to validate this works ok here....
                
                // general data queries here - will create other tables of data to add
                //    //   self.getGoogleHotelPlacesInfo() // brings back some random google places info!!!
                
            } else { print("error!") }
            print(error)
            
        }
    }
    
    func removeMarkersFromMap() {
        
        self.mapView.clear()
        locationPinSet = false
        markerInfo = []
        
    }

    // add the retour markers to map
    func addMarkersToMap() {
        
        var newBoundsWithMarkers = GMSCoordinateBounds()
        
        // Add marker for each result - do not add if one exists already //
        
        for i in results {
            
            var matching: Bool = false // Use to validate if the result  matches another in the array
            var arrayEmpty: Bool = true // Valudates whether or not the array is empty
            
            print("results = \(results)")
            print("individual result = \(i)")
            
            let geo = i.value(forKey: "GMSPlaceGeo") as! PFGeoPoint
            print("geo value = \(geo)")
            
            let lat = geo.value(forKey: "latitude") as! CLLocationDegrees
          
            let lon = geo.value(forKey: "longitude") as! CLLocationDegrees
            let loc = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
            //let types = i.value(forKey: "types_array")
           // let types = i.value(forKey: "types_array")
           // print("types = \(types)")
            var marker = GMSMarker(position: loc)

            marker.appearAnimation = GMSMarkerAnimation.pop
            //
            marker.tracksViewChanges = true
            marker.tracksInfoWindowChanges = true
            print(marker.position)
            marker.title = i.value(forKey: "GMSPlaceQuickName") as! String
            print("marker title (quick name) = \(marker.title)")
            var select = MapIconSelector()
            
            // select the right icon based on the type of place
            if i.value(forKey: "types") != nil {
            marker.icon = select.selectMapIcon(placeSet: i.value(forKey: "types") as! [String])
            } else { marker.icon = UIImage(named: "DefaultMapIcon.png")! }
            
            //marker.userData = results.index(of: i)
            marker.userData = results.index(of: i)
            newBoundsWithMarkers = newBoundsWithMarkers.includingCoordinate(loc) // update newbounds with existing copy including new marker coords
            // marker.icon = whichMarker(types as! Array)
          //  marker.icon = UIImage(named: "retourMapIcon.png") // Get the icon from the types array
            
            // check here and add to map if no entry in table exists //
            if !markerInfo.isEmpty {
                for f in markerInfo {
                    if loc.latitude == f.latitude && loc.longitude == f.longitude {
                        print("matching - not adding new marker")
                    } else { marker.map = mapView
                        print("adding new marker")}
                }
                
            } else { marker.map = mapView
                print("adding new marker - no markerinfo entries!")}
            
            print("new bounds = \(newBoundsWithMarkers.southWest)")
            
            print("markerinfo = \(markerInfo)")
            print("number of markers = \(markerInfo.count)")
            print("number of results = \(results.count)")
            

            
            markerInfo.append(loc)
            
        }
        
        // once iterated through all the markers update the bounds and use it in the google places search
        finalBounds = newBoundsWithMarkers
        // and then get the google places
        GetGooglePlaces()
        
        //let cam = GMSCameraUpdate.fit(newBoundsWithMarkers)
        let cam = GMSCameraUpdate.fit(newBoundsWithMarkers)
        //usMapView.animate(with: cam)
        mapView.animate(with: cam)
        
    }
    
    // This only runs if the searchText default has data - needs text to run and stops populating the map too much!
    func GetGooglePlaces() {
        
        var gmsplacesQueryFilter = "" as! String
        if defaults.value(forKey: "searchText") != nil {
            gmsplacesQueryFilter = defaults.value(forKey: "searchText") as! String
        }
        
        if gmsplacesQueryFilter != "" {
            print("query filter != nil ")
            GMSPlacesClient.shared().autocompleteQuery(gmsplacesQueryFilter, bounds: finalBounds, filter: nil) { (predictions, error) in
                if error == nil {
                    //print("final predictions for google within bounds = \(predictions)")
                    for i in predictions! {
                        print("individual prediction from google - add a marker for each!")
                        print(i)
                        GMSPlacesClient.shared().lookUpPlaceID(i.placeID!, callback: { (placeResult, error) in
                            if error == nil {
                                self.addGoogleMarkersToMap(place: placeResult!)
                            }
                        })
                        
                    }
                } else { print("error with google autocomplete")
                    print(error?.localizedDescription)}
            }
        }
    }
    
    func addGoogleMarkersToMap(place: GMSPlace) {
        print("adding google marker")
        let marker = GMSMarker(position: place.coordinate)
        marker.icon = UIImage(named: "googleMapLogo@2x.png")
        marker.map = mapView
        marker.snippet = place.name
        marker.userData = "gmsMarker" as! String
        
    }
    
    
    func mapView(_ mapView: GMSMapView!, didTap marker: GMSMarker!) -> Bool {

        // Display InfoWindow based on being a Google or Retour Marker
        if marker.userData is String { print("type string") }
        else {
        print(marker)
        var snippetText: String?
        var numberOfRelatedResults: Int = 0 // Count for number of Results at this Marker Location
        let locationID = marker.userData as! Int
        let GMSID = results[locationID].value(forKey: "GMSPlaceID") as! String
        print("gmsid below..")
        print(GMSID)
        self.lookupID = GMSID
        for h in results {
            if h.value(forKey: "GMSPlaceID") as! String == GMSID {
                numberOfRelatedResults = numberOfRelatedResults + 1
            }
        }
        if numberOfRelatedResults > 1 {
            snippetText = (String(numberOfRelatedResults) + " Blog Entries")
        } else { snippetText = (String(numberOfRelatedResults) + " Blog Entry") }
        print(snippetText)
        marker.snippet = snippetText
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print("tapping overlay")
        
    }
    

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
    //    let filtered: [PFObject] = (objects?.filter { ($0.value(forKey: "title") as! String).localizedCaseInsensitiveContains(self.searchText) || ($0.value(forKey: "body") as! String).localizedCaseInsensitiveContains(self.searchText) || ($0.value(forKey: "tags") as! String).localizedCaseInsensitiveContains(self.searchText) })!
    
        print("results at this point - \(markerObjects)")
        print("marker userdata = \(self.lookupID)")
        // create custom pop up window//
        var popup = PlaceViewPopUpController()
        popup = (self.storyboard?.instantiateViewController(withIdentifier: "placeViewPopUp"))! as! PlaceViewPopUpController
        popup.incomingData = results.filter{ ($0.value(forKey: "GMSPlaceID") as! String).localizedCaseInsensitiveContains(self.lookupID as! String)}
       // let infoAddition = Presentr(presentationType: .bottomHalf)
        let infoAddition = Presentr(presentationType: lowerCustomType)
        customPresentViewController(presenter, viewController: popup, animated: true) {
          //  print("completed - load last few entries into here or extra button to take you to table view")
        }
    }


    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        var window = Bundle.main.loadNibNamed("MapInfoWindow", owner: self, options: nil)?.first as! MapInfoWindow
        
        if marker.userData is String { print("type string") } else {

        print("retour item so returning defined windows")

      //  let window = Bundle.main.loadNibNamed("MapInfoWindow", owner: self, options: nil)?.first as! MapInfoWindow
        
        window.placeNameText.text = marker.title
        window.snippetText.text = marker.snippet
        marker.tracksViewChanges = true
        
        //get some google data here and add it the window
        
        print("id to search")
        print(self.lookupID)
         
        // Add Google Place Reviews Data
        GoogleSearch.getPlacesAndPopulateMap(markerView: marker, placeID: self.lookupID, textLabel: window.googleLabel1, textLabel2: window.googleLabel2)
        
        
        GMSPlacesClient.shared().lookUpPlaceID(self.lookupID) { (placeInfo, error) in
            if error == nil {
                print("no error")
                print(placeInfo?.formattedAddress)
                let text = placeInfo?.formattedAddress
             //   let reviewData = placeInfo?.value(forKey: "reviews") as! String
             //   print(reviewData)
                window.addressText.text = text
            }
        }

        }
        return window
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selecting item")
    }
    
    func mapCameraToMyLocation(location: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition(target: location, zoom: 10, bearing: 0, viewingAngle: 1)
        mapView.animate(to: camera)
    }

}

