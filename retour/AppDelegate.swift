//
//  AppDelegate.swift
//  Retour
//
//  Paul Lancashire
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import Parse
import ParseFacebookUtilsV4
import FBSDKCoreKit
import FBSDKLoginKit
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    
    let locManager = CLLocationManager()
    var retourLocationManager = CLLocationManager()
    let nc = NotificationCenter.default
    let prefs = UserDefaults.standard
    var loc = CLLocation()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        prefs.setValue("Any", forKey: "status")
        
//        let configuration = ParseClientConfiguration {
//            $0.applicationId = "dev"
//            $0.server = "http://localhost:1337/parse"
//            
//        }
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "019f49dce17c38276fjdt"
            $0.server = "https://festive-quanta-621.appspot.com/parse"
            
        }
        
        Parse.initialize(with: configuration)
        // Override point for customization after application launch.
        
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        locManager.startUpdatingLocation()
        retourLocationManager.delegate = self
        retourLocationManager.requestAlwaysAuthorization()
        retourLocationManager.startUpdatingLocation()
        
        
        GMSPlacesClient.provideAPIKey("AIzaSyC9--UMJpT046hj-geZFDzP1RXBCpbJhVU")
        GMSServices.provideAPIKey("AIzaSyC9--UMJpT046hj-geZFDzP1RXBCpbJhVU")
        
        let defaultACL = PFACL()
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        
      //  PFUser.enableAutomaticUser()
        
        return true
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("user authorization state change")
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //  print("updated location below")
        //  print(locations)
    }
    
}
