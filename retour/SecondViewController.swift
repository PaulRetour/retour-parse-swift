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


class SecondViewController: UIViewController {

    @IBOutlet weak var mapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindCancelFromPrefs(sender: UIStoryboardSegue) {
        print("unwind")
    }

}

