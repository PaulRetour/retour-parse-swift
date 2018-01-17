//
//  TripsViewController.swift
//  retour
//
//  Created by Paul Lancashire on 15/08/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Parse

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tripsLabel: UILabel!
    
    @IBOutlet var tripsTableView: UITableView!
    
    var tripData = [PFObject]()

    var tripCount = 0
    
    func checkForTrips() {
        // if there ARE trips
        
        var myTrips = PFQuery(className: "trips")
        myTrips.whereKey("user", equalTo: PFUser.current())
        myTrips.findObjectsInBackground { (objects, error) in
            if error == nil {
                print("trips are - \(objects)")
                print("trip count - \(objects?.count)")
                if objects != nil { self.tripCount = (objects?.count)!
                self.tripData = objects!
                }
                if self.tripCount > 0 {
                    self.tripsLabel.isHidden = true
                    self.tripsTableView.isHidden = false
                    self.tripsTableView.reloadData()
                } else {
                    self.tripsLabel.isHidden = false
                    self.tripsTableView.isHidden = true
                }
            }
        }

    }
    
    override func viewDidLoad() {
        let tripsNib = UINib(nibName: "TripsTableCell", bundle: nil)
        tripsTableView.register(tripsNib, forCellReuseIdentifier: "TripsTableCell")
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        tripsTableView.estimatedRowHeight = 200
        tripsTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkForTrips()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tripcount = \(tripData.count)")
        return tripData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripsTableCell", for: indexPath) as! TripsTableCell
        let cellData = tripData[indexPath.row]
        cell.tripTitle.text = cellData.value(forKey: "tripName") as! String
        cell.tripDetail.text = cellData.value(forKey: "tripDesc") as! String
        cell.blogCount.text = "3 Entries"
        cell.imageView?.alpha = 1.5
        
        if cellData.object(forKey: "tripImage") != nil {
            let tripImage = cellData.value(forKey: "tripImage") as! PFFile
            tripImage.getDataInBackground(block: { (data, error) in
                if error == nil {
                    let finalImage: UIImage = UIImage(data: data!)!
                    cell.tripImage.image = finalImage
                }
            })
        }
        print("returning cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selecting cell")
        let celldata = tripData[indexPath.row]
        print(celldata)
    }
}
