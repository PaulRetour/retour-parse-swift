//
//  FavouritesViewController.swift
//  retour
//
//  Created by Paul Lancashire on 11/07/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Parse

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var favouriteResults = [PFObject]()
    let me = PFUser.current()
    
    var faveBlogs = Array<String>()
    
    @IBOutlet var favouritesTableView: UITableView!
    
    func getAllMyFavourites() {
        var query = PFQuery(className: "blogs")
        
        faveBlogs = me?.value(forKey: "faveBlogs") as! Array<String>
        
        query.whereKey("objectId", containsAllObjectsIn: faveBlogs)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.favouriteResults = objects!
                print("results to populate - \(self.favouriteResults)")
                print("number of items in favourites - \(self.favouriteResults.count)")
                self.favouritesTableView.reloadData()
            } else { print("error - \(error)") }
        }
        
    }
    
    override func viewDidLoad() {
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
        getAllMyFavourites()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllMyFavourites()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteResults.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
}
