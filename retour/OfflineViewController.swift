//
//  OfflineViewController.swift
//  retour
//
//  Created by Paul Lancashire on 24/07/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Parse

class OfflineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var offlineQuery = PFQuery(className: "blogs")
    var offlineData = [PFObject]()
    
    @IBOutlet var offlineTableView: UITableView!
    @IBOutlet var noOfflineBlogsLabel: UILabel!
    
    override func viewDidLoad() {
        noOfflineBlogsLabel.isHidden = true
        print("offline view controller loading")
        offlineTableView.dataSource = self
        offlineTableView.delegate = self
        
        let offlineNib = UINib(nibName: "OfflineTableViewCell", bundle: nil)
        offlineTableView.register(offlineNib, forCellReuseIdentifier: "OfflineTableViewCell")
        
        offlineTableView.estimatedRowHeight = 300
        offlineTableView.rowHeight = UITableViewAutomaticDimension
        
        
       // getMyLocalBlogs()
    }
    
    func getMyLocalBlogs() {
        self.noOfflineBlogsLabel.isHidden = true
        offlineQuery.fromLocalDatastore()
        offlineQuery.findObjectsInBackground { (allObjects, error) in
            if error == nil {
                if (allObjects?.count)! > 0 {
            self.noOfflineBlogsLabel.isHidden = true
            print("offline objects")
            print("offline count = \(allObjects?.count)")
            self.offlineData = allObjects!
            self.offlineTableView.reloadData()
            print(allObjects)
            print(allObjects?.count)
                } else {self.noOfflineBlogsLabel.isHidden = false
                print("no offline blogs")}
            } else {
                print("offline error")
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getMyLocalBlogs()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of offline rows = \(self.offlineData.count)")
        return offlineData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfflineTableViewCell", for: indexPath) as! OfflineTableViewCell
        let cellData = offlineData[indexPath.row]
        cell.titleLabel.text = cellData.value(forKey: "title") as! String
        cell.bodyLabel.text = cellData.value(forKey: "body") as! String
        cell.tagsLabel.text = cellData.value(forKey: "tags") as! String
        
        print("offline cell title = \(cell.titleLabel.text)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selecting row \(indexPath.row)")
        print(offlineData[indexPath.row])
    }
}
