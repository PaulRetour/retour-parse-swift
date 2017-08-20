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
import Presentr
import ReachabilitySwift

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let reach = Reachability()
    
    var favouriteResults = [PFObject]()
    let me = PFUser.current()
    let retourStandards = standards()
    
    var faveBlogs = Array<String>()
    
    @IBOutlet var noFaveLabel: UILabel!
    
    @IBOutlet var favouritesTableView: UITableView!
    
    let presentBlogView = Presentr(presentationType: .fullScreen)
    
    let cellImage1Nib = UINib(nibName: "SingleImageTableViewCell", bundle: nil)
    let cellImage2Nib = UINib(nibName: "TwoImageTableViewCell", bundle: nil)
    let cellImage3Nib = UINib(nibName: "ThreeImageTableViewCell", bundle: nil)
    
    func getAllMyFavourites() {
        var query = PFQuery(className: "blogs")
        if PFUser.current()?.value(forKey: "faveBlogs") != nil {
        faveBlogs = me?.value(forKey: "faveBlogs") as! Array<String>
        print("faveBlogs = \(faveBlogs)")
        }
      //  query.whereKey("objectId", containsAllObjectsIn: faveBlogs)
        
        query.whereKey("objectId", containedIn: faveBlogs)
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if objects!.count > 0 {
                self.noFaveLabel.isHidden = true
                self.favouriteResults = objects!
                print("results to populate - \(self.favouriteResults)")
                print("number of items in favourites - \(self.favouriteResults.count)")
                self.favouritesTableView.reloadData()
                } else {
                    self.noFaveLabel.isHidden = false
                }
            } else { print("error - \(error)") }
        }
        
    }
    
    override func viewDidLoad() {
        self.noFaveLabel.isHidden = true
      //  favouritesTableView.backgroundColor = retourStandards.retourGreen
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
        favouritesTableView.rowHeight = UITableViewAutomaticDimension
        favouritesTableView.estimatedRowHeight = 400
        
        if reach!.isReachable {
        getAllMyFavourites()
        } else {
            noFaveLabel.text = "Offline"
        
        }
        favouritesTableView.register(cellImage1Nib, forCellReuseIdentifier: "SingleImageTableViewCell")
        favouritesTableView.register(cellImage2Nib, forCellReuseIdentifier: "TwoImageTableViewCell")
        favouritesTableView.register(cellImage3Nib, forCellReuseIdentifier: "ThreeImageTableViewCell")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let blogView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
        let blogCellData = favouriteResults[indexPath.row] as! PFObject
        blogView.incomingData = blogCellData
        present(blogView, animated: true) { 
            print("presenting")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // var cell = UITableViewCell()
        let cellData = favouriteResults[indexPath.row] as! PFObject

        // Select a cell based on the number of images in the blog object.. count backwards! //
        if cellData.object(forKey: "image2file") != nil {
            print("threeimagecellfavourite")
            var cell = tableView.dequeueReusableCell(withIdentifier: "ThreeImageTableViewCell", for: indexPath) as! ThreeImageTableViewCell
            if cellData.value(forKey: "body") != nil { cell.bodyLabel.text = cellData.value(forKey: "body") as! String }
            if cellData.value(forKey: "title") != nil { cell.titleLabel.text = cellData.value(forKey: "title") as! String }
            if cellData.value(forKey: "GMSPlaceQuickName") != nil { cell.locationLabel.text = cellData.value(forKey: "GMSPlaceQuickName") as! String }
            let cellDataUser = cellData.value(forKey: "userPoint") as! PFObject
            
            cellDataUser.fetchIfNeededInBackground(block: { (object, error) in
                if error == nil {
                    cell.usernameLabel.text = cellDataUser.value(forKey: "username2") as! String
                }
            })

            let image1 = cellData.value(forKey: "image0file") as! PFFile
            let image2 = cellData.value(forKey: "image1file") as! PFFile
            let image3 = cellData.value(forKey: "image2file") as! PFFile
            let userImage = cellDataUser.value(forKey: "userImage") as! PFFile
            
            userImage.getDataInBackground(block: { (data, error) in
                if error == nil {
                    let finalUserImage: UIImage = UIImage(data: data!)!
                    cell.userImageView.image = finalUserImage
                }
            })
            
                
            image1.getDataInBackground(block: { (data, error) in
                if error == nil {
                    let finalImage1: UIImage = UIImage(data: data!)!
                    cell.image1View.image = finalImage1
                }
            })
            
            image2.getDataInBackground(block: { (data, error) in
                if error == nil {
                    let finalImage2: UIImage = UIImage(data: data!)!
                    cell.image2View.image = finalImage2
                }
            })
            
            image3.getDataInBackground(block: { (data, error) in
                if error == nil {
                    let finalImage3: UIImage = UIImage(data: data!)!
                    cell.image3View.image = finalImage3
                }
            })
            return cell
            
        } else if cellData.object(forKey: "image1file") != nil {
            print("twoimagecellfavourite")
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "TwoImageTableViewCell", for: indexPath) as! TwoImageTableViewCell
            cell.userImage.layer.cornerRadius = (cell.userImage.bounds.height / 2)
            cell.userImage.clipsToBounds = true
            let cellDataUser = cellData.value(forKey: "userPoint") as! PFObject
            
            if cellData.value(forKey: "body") != nil { cell.bodyLable.text = cellData.value(forKey: "body") as! String }
            if cellData.value(forKey: "title") != nil { cell.titleLabel.text = cellData.value(forKey: "title") as! String }
            if cellData.value(forKey: "tags") != nil { cell.tagsLabel.text = cellData.value(forKey: "tags") as! String }
            if cellData.value(forKey: "username2") != nil { cell.usernameLabel.text = cellDataUser.value(forKey: "username2") as! String }
            if cellData.value(forKey: "GMSplaceQuickName") != nil { cell.locationLabel.text = cellData.value(forKey: "GMSPlaceQuickName") as! String }
            
            let image1 = cellData.value(forKey: "image0file") as! PFFile
            let image2 = cellData.value(forKey: "image1file") as! PFFile

            cellDataUser.fetchIfNeededInBackground(block: { (object, error) in
                if error == nil {
                    cell.usernameLabel.text = cellDataUser.value(forKey: "username2") as! String
                }
            })
            
            let userImage = cellDataUser.value(forKey: "userImage") as! PFFile
            
            userImage.getDataInBackground(block: { (data, error) in
                if error == nil {
                    let finalUserImage: UIImage = UIImage(data: data!)!
                    cell.userImage.image = finalUserImage
                }
            })
                
            
            
            image1.getDataInBackground(block: { (data, error) in
                if error == nil {
                    let finalImage1: UIImage = UIImage(data: data!)!
                    cell.image1File.image = finalImage1
                }
            })
            
            image2.getDataInBackground(block: { (data, error) in
                if error == nil {
                    let finalImage2: UIImage = UIImage(data: data!)!
                    cell.image2File.image = finalImage2
                }
            })
        
            return cell
        } else {
            
            
            print("singleimagecellfavourite")
            var cell = tableView.dequeueReusableCell(withIdentifier: "SingleImageTableViewCell", for: indexPath) as! SingleImageTableViewCell
            print("celldata")
            print(cellData)
            let cellDataUser = cellData.value(forKey: "userPoint") as! PFObject
          //  cellData.fetchInBackground()
            cell.bodyLabel.text = cellData.value(forKey: "body") as! String
            cell.titleLabel.text = cellData.value(forKey: "title") as! String
            cell.locationLabel.text = cellData.value(forKey: "GMSPlaceQuickName") as! String
            cell.tagsLabel.text = cellData.value(forKey: "tags") as! String
            cell.usernameLabel.text = cellDataUser.value(forKey: "username2") as! String
            cell.userImage.layer.cornerRadius = (cell.userImage.bounds.height / 2)
            cell.userImage.clipsToBounds = true
            let image1 = cellData.value(forKey: "image0file") as! PFFile

            image1.getDataInBackground(block: { (data, error) in
                if error == nil {
                    let finalImage1: UIImage = UIImage(data: data!)!
                    cell.image1File.image = finalImage1
                }
            })
            if cellDataUser.value(forKey: "userImage") != nil {
            let userImage = cellDataUser.value(forKey: "userImage") as! PFFile
            userImage.getDataInBackground(block: { (data, error) in
                if error == nil {
                    let finalUserImage: UIImage = UIImage(data: data!)!
                    cell.userImage.image = finalUserImage
                }
            })
            }
            
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
}
