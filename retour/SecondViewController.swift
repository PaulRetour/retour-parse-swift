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
import Presentr


class SecondViewController: UIViewController {
    
    let presenter = Presentr(presentationType: .bottomHalf)
    
    var prefsPresentr = Presentr(presentationType: .fullScreen)
    
    var prefsVC = UIViewController()
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBAction func prefsButton(_ sender: Any) {
        
        customPresentViewController(prefsPresentr, viewController:
            prefsVC, animated: true) { 
                
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       // prefsPresentr.presentationType = .fullScreen
        prefsPresentr.transitionType = .coverHorizontalFromRight

        prefsVC = (self.storyboard?.instantiateViewController(withIdentifier: "PrefsViewController"))!
        presenter.backgroundOpacity = 0.8
        
        mapView.backgroundColor = UIColor.white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindCancelFromPrefs(sender: UIStoryboardSegue) {
        print("unwind")
    }
    
    
    @IBAction func unwindSaveFromPrefs(sender: UIStoryboardSegue) {
        print("unwind and save")
    }


}

