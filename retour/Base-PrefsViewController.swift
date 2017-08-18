////
////  PrefsViewController.swift
////  newretour
////
////  Created by Paul Lancashire on 27/08/2015.
////  Copyright (c) 2015 Paul Lancashire. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class PrefsViewController: UIViewController {
//    
//    // Required - NSUserDefaults
//    var defaults = UserDefaults.standard
//    
//    @IBOutlet weak var testButton: UIButton!
//    
//    @IBOutlet weak var LikeMeLabelButton: UIButton!
//    
//    @IBOutlet weak var likeMeSwitch: UISwitch!
//    
//    @IBOutlet weak var searchValueField: UITextField!
//    
//    @IBOutlet weak var searchDistanceSlider: UISlider!
//    
//    @IBOutlet weak var timeFrameControl: UISegmentedControl!
//    
//    @IBOutlet weak var statusSegmentControl: UISegmentedControl!
//    
//    @IBOutlet weak var ageRangeSegmentControl: UISegmentedControl!
//    
//    var defaultSwitch: Bool?
//    
//    override func viewDidLoad() {
//        
//        print("Loading Preferences View")
//        // Load Stored Preferences from NSUserDefaults
//        getInitStateFromPrefs()
//        
//
//    }
//    
//    @IBAction func flickSwitch(sender: AnyObject) {
//        
//        flickLikeMeSwitch()
//        
//    }
//    
//    func hideAll() {
//        print("hiding")
//        statusSegmentControl.hidden = true
//        ageRangeSegmentControl.hidden = true
//        likeMeSwitch.on = true
//        
//    }
//    
//    func displayAll() {
//        print("displaying")
//        statusSegmentControl.hidden = false
//        ageRangeSegmentControl.hidden = false
//        likeMeSwitch.on = false
//    }
//    
//    func flickLikeMeSwitch() {
//        
//        // on or off, setting bool
//        print("flicking")
//        if likeMeSwitch.on == true {
//            hideAll()
//        } else {
//            displayAll()
//            }
//        }
//    
//    // At View Did Load, run this to get stored prefs
//    func getInitStateFromPrefs() {
//        
//        print("Getting Preferences from NSUserDefaults")
//        
//        // Get auto on/off awitch status
//        
//      //  print("all incoming - \(defaults.boolForKey(defaultSwitch?.boolValue))")
//        
//      // edited if let likeMeSwitchResult = defaults.value(forKey: "defaultsSwitch") {
//        if let likeMeSwitchResult = defaults.valueForKey("defaultsSwitch") {
//            print("likemeswitch type = \(likeMeSwitchResult)")
//         // edited  if (likeMeSwitchResult as! NSObject) as! Decimal == 0 {
//            if (likeMeSwitchResult as! NSObject) as! NSDecimalNumber == 0 {
//            }
//                displayAll()
//            }
//            
//          //edited  if (likeMeSwitchResult as! NSObject) as! Decimal == 1 {
//        if let likeMeSwitchResult = defaults.valueForKey("defaultsSwitch") {
//        if (likeMeSwitchResult as! NSObject) as! NSDecimalNumber == 1 {
//        }
//                hideAll()
//            }
//            
//         else {
//            print("No Like Me Switch Store - setting to On")
//            displayAll()
//            
//        }
//
//
//        
//        // Get Status Setting - if nothing exists, set it to 0 (Any)
//        var statusOutput : String?
//
//        if let statusFromPrefs = defaults.valueForKey("status") {
//            switch statusFromPrefs {
//            case "Any" as String :
//                statusSegmentControl.selectedSegmentIndex = 0
//                statusOutput = "Any"
//            case "Single" as String :
//                statusSegmentControl.selectedSegmentIndex = 1
//                statusOutput = "Single"
//            case "Married" as String :
//                statusSegmentControl.selectedSegmentIndex = 2
//                statusOutput = "Married"
//            case "Relationship" as String :
//                statusSegmentControl.selectedSegmentIndex = 3
//                statusOutput = "Relationship"
//            default :
//                statusSegmentControl.selectedSegmentIndex = 0
//                statusOutput = "Any"
//            }
//        } else { print("no status set, so setting 0")
//            statusSegmentControl.selectedSegmentIndex = 0
//            statusOutput = "Any - None Set"
//            
//        }
//        
//        // Get Age Range Setting - If nothing exists, set it to 0 (Any)
//        var ageOutput : String?
//        if let ageFromPrefs = defaults.valueForKey("ageRange") {
//            switch ageFromPrefs {
//            case "Any" as String :
//                ageRangeSegmentControl.selectedSegmentIndex = 0
//                ageOutput = "Any"
//            case "sixteenThirty" as String :
//                ageRangeSegmentControl.selectedSegmentIndex = 1
//                ageOutput = "16-30"
//            case "thirtyOneFortyFive" as String :
//                ageRangeSegmentControl.selectedSegmentIndex = 2
//                ageOutput = "31-45"
//            case "fortyFiveSixty" as String :
//                ageRangeSegmentControl.selectedSegmentIndex = 3
//                ageOutput = "45-60"
//            case "sixtyPlus" as String :
//                ageRangeSegmentControl.selectedSegmentIndex = 4
//                ageOutput = "60+"
//            default :
//                ageRangeSegmentControl.selectedSegmentIndex = 0
//                ageOutput = "Any"
//            }
//        } else { print("no age range saved - setting to 0")
//            ageRangeSegmentControl.selectedSegmentIndex = 0
//            ageOutput = "Any - None Set"
//        }
//
//        // Get Distance Setting - If nothing exists, set to 50 (float)
//        var distanceOutput: Float?
//        if let initDistance = defaults.valueForKey("searchDistance") {
//            searchDistanceSlider.value = initDistance as! Float
//            distanceOutput = initDistance as! Float
//        } else {
//            print("no distance setting recorded, so setting to 50")
//            searchDistanceSlider.value = 50 
//            distanceOutput = 50
//            
//        }
//        
//        // Get Search Timefram from Prefs - If nothing exists, set to 24 hours
//        var timeframeOutput: String?
//        if let testinitTimeFrame = defaults.valueForKey("timeframe") {
//            switch testinitTimeFrame {
//            case "day" as String :
//                print("day")
//                timeFrameControl.selectedSegmentIndex = 0
//                timeframeOutput = "day"
//            case "twodays" as String :
//                print("twodays")
//                timeFrameControl.selectedSegmentIndex = 1
//                timeframeOutput = "two days"
//            case "week" as String :
//                print("week")
//                timeFrameControl.selectedSegmentIndex = 2
//                timeframeOutput = "one week"
//            case "month" as String :
//                print("month")
//                timeFrameControl.selectedSegmentIndex = 3
//                timeframeOutput = "one month"
//            default :
//                timeFrameControl.selectedSegmentIndex = 0
//                timeframeOutput = "default one day"
//            }
//
//        } else {
//            print("no search time exists so setting to 24 (segment 0)")
//            timeFrameControl.selectedSegmentIndex = 0
//            timeframeOutput = "one day - none set"
//        }
//        
//        print("Preferences Retrieved")
//        print("defaults - \(likeMeSwitch.on)")
//        print("status - \(statusOutput)")
//        print("age range - \(ageOutput)")
//        print("search distance - \(distanceOutput)")
//        
//    }
//    
//    // Needed for unwind and storing and sending values back to ViewController
//   // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "unwindFromPrefs" {
//            
//            // setup destination segue controller
//            let dst = segue.destinationViewController as! UsHomeViewController
//            
//            // if using profile defaults, set the bool value of the profile prefs option in Us
//            if likeMeSwitch.on == true {
//            dst.useProfilePrefs = true
//            } else { dst.useProfilePrefs = false }
//            
//            // store preferences here
//            print("Saving User Preferences")
//            
//            // Store distance // 
//            
//          //  defaults.set(searchDistanceSlider.value, forKey: "searchDistance")
//            defaults.setValue(searchDistanceSlider.value, forKey: "searchDistance")
//            var info = defaults.valueForKey("searchDistance")
//
//            // Store defaults On Switch //
//            
//         //   defaults.set(likeMeSwitch.isOn, forKey: "defaultsSwitch")
//            defaults.setValue(likeMeSwitch.on, forKey: "defaultsSwitch")
//            print("defaults switch = \(likeMeSwitch.on)")
//            
//            // Save Status Segment ID as String //
//            
//            var statusToSave: String?
//            
//            switch statusSegmentControl.selectedSegmentIndex {
//            case 0:
//                statusToSave = "Any"
//            case 1:
//                statusToSave = "Single"
//            case 2:
//                statusToSave = "Married"
//            case 3:
//                statusToSave = "Relationship"
//            default:
//                statusToSave = "Any"
//            }
//            
//            defaults.setValue(statusToSave, forKey: "status")
//            
//            // Save Age Range ID as String //
//            
//            var ageRangeToSave: String?
//            
//            switch ageRangeSegmentControl.selectedSegmentIndex {
//            case 0:
//                ageRangeToSave = "Any"
//            case 1:
//                ageRangeToSave = "sixteenThirty"
//            case 2:
//                ageRangeToSave = "thirtyOneFortyFive"
//            case 3:
//                ageRangeToSave = "fortyFiveSixty"
//            case 4:
//                ageRangeToSave = "sixtyPlus"
//            default:
//                ageRangeToSave = "Any"
//            }
//            
//            defaults.setValue(ageRangeToSave, forKey: "ageRange")
//            
//            // Save Time Frame Selection as String //
//            
//            var timeFrameOutput: String
//            
//            switch timeFrameControl.selectedSegmentIndex
//            {
//            case 0 :
//                timeFrameOutput = "day"
//                
//            case 1 :
//                timeFrameOutput = "twodays"
//            case 2 :
//                timeFrameOutput = "week"
//            case 3 :
//                timeFrameOutput = "month"
//            default :
//                timeFrameOutput = "day"
//                
//            }
//            
//            defaults.setValue(timeFrameOutput, forKey: "timeframe")
//            
//        }
//    }
//}
