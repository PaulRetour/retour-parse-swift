//
//  PrefsViewController.swift
//  retour
//
//  Created by Paul Lancashire on 02/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit

class PrefsViewControoler: UIViewController, UISearchBarDelegate {
    
    let retourSandards = standards()
    
    var defaults = UserDefaults.standard
    var defaultSwitch: Bool?
    // Get Status Setting - if nothing exists, set it to 0 (Any)
    var statusOutput : String?
    
    // TO REPLACE WITH IBOUTLET //
    
    
    @IBOutlet weak var likeMeSwitch: UISwitch!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchDistanceSlider: UISlider!
    @IBOutlet weak var statusSegmentControl: UISegmentedControl!
    @IBOutlet weak var ageRangeSegmentControl: UISegmentedControl!
    @IBOutlet weak var timeFrameControl: UISegmentedControl!
    
    override func viewDidLoad() {
        
          //  searchDistanceSlider.setThumbImage("sliderKnob48.png", for: UIControlState.normal)
        searchDistanceSlider.setThumbImage(UIImage(named: "sliderKnob48.png"), for: UIControlState.normal)
        searchDistanceSlider.setThumbImage(UIImage(named: "sliderKnob48.png"), for: UIControlState.highlighted)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("nsuserdefaults...")
        print(defaults)
        if defaults.value(forKey: "searchDistance") == nil  {
            print("no defaults, so set with function")
        }
        searchBar.delegate = self
        getInitStateFromPrefs()
        searchDistanceSlider.minimumTrackTintColor = retourSandards.retourGreen
        searchDistanceSlider.maximumTrackTintColor = retourSandards.retourGreen
        likeMeSwitch.onTintColor = retourSandards.retourGreen
        statusSegmentControl.tintColor = retourSandards.retourGreen
        ageRangeSegmentControl.tintColor = retourSandards.retourGreen
        timeFrameControl.tintColor = retourSandards.retourGreen
    }
    
    @IBAction func flickSwitch(sender: AnyObject) {
        flickLikeMeSwitch()
    }
    
    //  Move all save and loads to here...
    
    func savePrefs() {
        
        print("saving prefs function")
        // search distance //
        defaults.setValue(searchDistanceSlider.value, forKey: "searchDistance")
        var info = defaults.value(forKey: "searchDistance")
        
        // defaults switch - check! //
        defaults.setValue(likeMeSwitch.isOn, forKey: "defaultsSwitch")
        print("defaults switch = \(likeMeSwitch.isOn)")
        
        // msrital status //
        var statusToSave: String?
        switch statusSegmentControl.selectedSegmentIndex {
        case 0:
            statusToSave = "Any"
        case 1:
            statusToSave = "Single"
        case 2:
            statusToSave = "Married"
        case 3:
            statusToSave = "Relationship"
        default:
            statusToSave = "Any"
        }
        defaults.setValue(statusToSave, forKey: "status")
        
        // age range //
        var ageRangeToSave: String?
        switch ageRangeSegmentControl.selectedSegmentIndex {
        case 0:
            ageRangeToSave = "Any"
        case 1:
            ageRangeToSave = "sixteenThirty"
        case 2:
            ageRangeToSave = "thirtyOneFortyFive"
        case 3:
            ageRangeToSave = "fortyFiveSixty"
        case 4:
            ageRangeToSave = "sixtyPlus"
        default:
            ageRangeToSave = "Any"
        }
        defaults.setValue(ageRangeToSave, forKey: "ageRange")
        
        // time frame //
        var timeFrameOutput: String
        switch timeFrameControl.selectedSegmentIndex
        {
        case 0 :
            timeFrameOutput = "day"
        case 1 :
            timeFrameOutput = "twodays"
        case 2 :
            timeFrameOutput = "week"
        case 3 :
            timeFrameOutput = "month"
        default :
            timeFrameOutput = "day"
        }
        defaults.setValue(timeFrameOutput, forKey: "timeframe")
    }
    
    func loadPrefs() {
        
    }
    
    func hideAll() {
        print("hiding")
        statusSegmentControl.isHidden = true
        ageRangeSegmentControl.isHidden = true
        likeMeSwitch.isOn = true
    }
    
    func displayAll() {
        print("displaying")
        statusSegmentControl.isHidden = false
        ageRangeSegmentControl.isHidden = false
        likeMeSwitch.isOn = false
    }
    
    func flickLikeMeSwitch() {
        // on or off, setting bool
        print("flicking")
        if likeMeSwitch.isOn == true {
            hideAll()
        } else {
            displayAll()
        }
    }
    
    // At View Did Load, run this to get stored prefs
    func getInitStateFromPrefs() {
        
        print("Getting Preferences from NSUserDefaults")
        print(defaults.value(forKey: "defaultsSwitch"))
        
        // Get auto on/off awitch status
        
        //  print("all incoming - \(defaults.boolForKey(defaultSwitch?.boolValue))")
        
        // edited if let likeMeSwitchResult = defaults.value(forKey: "defaultsSwitch") {
        if let likeMeSwitchResult = defaults.value(forKey: "defaultsSwitch") {
            print("likemeswitch 0 type = \(likeMeSwitchResult)")
            // edited  if (likeMeSwitchResult as! NSObject) as! Decimal == 0 {
            if (likeMeSwitchResult as! Bool) == false {
                print("display all")
                displayAll()
            }
            
        }
        
        //edited  if (likeMeSwitchResult as! NSObject) as! Decimal == 1 {
        if let likeMeSwitchResult = defaults.value(forKey: "defaultsSwitch") {
            if (likeMeSwitchResult as! Bool) == true {
                print("hide all")
                hideAll()
            }

        }
            
        else {
            print("No Like Me Switch Store - setting to On")
            displayAll()
            
        }
        
        
        
        // Get Status Setting - if nothing exists, set it to 0 (Any)
        var statusOutput : String?
        
        if let statusFromPrefs = defaults.value(forKey: "status") {
            switch statusFromPrefs {
            case "Any" as String :
                statusSegmentControl.selectedSegmentIndex = 0
                statusOutput = "Any"
            case "Single" as String :
                statusSegmentControl.selectedSegmentIndex = 1
                statusOutput = "Single"
            case "Married" as String :
                statusSegmentControl.selectedSegmentIndex = 2
                statusOutput = "Married"
            case "Relationship" as String :
                statusSegmentControl.selectedSegmentIndex = 3
                statusOutput = "Relationship"
            default :
                statusSegmentControl.selectedSegmentIndex = 0
                statusOutput = "Any"
            }
        } else { print("no status set, so setting 0")
            statusSegmentControl.selectedSegmentIndex = 0
            statusOutput = "Any - None Set"
            
        }
        
        // Get Age Range Setting - If nothing exists, set it to 0 (Any)
        var ageOutput : String?
        if let ageFromPrefs = defaults.value(forKey: "ageRange") {
            switch ageFromPrefs {
            case "Any" as String :
                ageRangeSegmentControl.selectedSegmentIndex = 0
                ageOutput = "Any"
            case "sixteenThirty" as String :
                ageRangeSegmentControl.selectedSegmentIndex = 1
                ageOutput = "16-30"
            case "thirtyOneFortyFive" as String :
                ageRangeSegmentControl.selectedSegmentIndex = 2
                ageOutput = "31-45"
            case "fortyFiveSixty" as String :
                ageRangeSegmentControl.selectedSegmentIndex = 3
                ageOutput = "45-60"
            case "sixtyPlus" as String :
                ageRangeSegmentControl.selectedSegmentIndex = 4
                ageOutput = "60+"
            default :
                ageRangeSegmentControl.selectedSegmentIndex = 0
                ageOutput = "Any"
            }
        } else { print("no age range saved - setting to 0")
            ageRangeSegmentControl.selectedSegmentIndex = 0
            ageOutput = "Any - None Set"
        }
        
        // Get Distance Setting - If nothing exists, set to 50 (float)
        var distanceOutput: Float?
        if let initDistance = defaults.value(forKey: "searchDistance") {
            searchDistanceSlider.value = initDistance as! Float
            distanceOutput = initDistance as! Float
        } else {
            print("no distance setting recorded, so setting to 50")
            searchDistanceSlider.value = 50
            distanceOutput = 50
            
        }
        
        // Get Search Timefram from Prefs - If nothing exists, set to 24 hours
        var timeframeOutput: String?
        if let testinitTimeFrame = defaults.value(forKey: "timeframe") {
            switch testinitTimeFrame {
            case "day" as String :
                print("day")
                timeFrameControl.selectedSegmentIndex = 0
                timeframeOutput = "day"
            case "twodays" as String :
                print("twodays")
                timeFrameControl.selectedSegmentIndex = 1
                timeframeOutput = "two days"
            case "week" as String :
                print("week")
                timeFrameControl.selectedSegmentIndex = 2
                timeframeOutput = "one week"
            case "month" as String :
                print("month")
                timeFrameControl.selectedSegmentIndex = 3
                timeframeOutput = "one month"
            default :
                timeFrameControl.selectedSegmentIndex = 0
                timeframeOutput = "default one day"
            }
            
        } else {
            print("no search time exists so setting to 24 (segment 0)")
            timeFrameControl.selectedSegmentIndex = 0
            timeframeOutput = "one day - none set"
        }
        
        print("Preferences Retrieved")
        print("defaults - \(likeMeSwitch.isOn)")
        print("status - \(statusOutput)")
        print("age range - \(ageOutput)")
        print("search distance - \(distanceOutput)")
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("editing search text")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        performSegue(withIdentifier: "unwindCancelFromPrefsWithSender", sender: self)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("save prefs, and use prefs to created search with following search text")
        searchButton(self)
        
    }
    @IBAction func searchButton(_ sender: Any) {
        savePrefs()
        performSegue(withIdentifier: "unwindSaveFromPrefsWithSender", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Do the save stuff here //
        if segue.identifier == "unwindSaveFromPrefsWithSender" {
            print("saving prefs here...")
            let returnVC = segue.destination as! SecondViewController
            print("returning text to SecondVC")
            
            if searchBar.text == "" || searchBar.text == " " {
            returnVC.searchText = searchBar.text!
                returnVC.toFilter = false
            } else {
            returnVC.searchText = searchBar.text!
            returnVC.toFilter = true }
            
        } else {
            print("other segue prepare")
        }
    }
    
    override func hideKeyboardWhenTappedAround() {
        
    }
}
