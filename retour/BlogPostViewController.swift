//
//  BlogPostViewController.swift
//  retour
//
//  Created by Paul Lancashire on 12/07/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Presentr

class BlogPostViewController: UIViewController {
    
    let retourStandards = standards()
   
    @IBOutlet var navBar: UINavigationBar!
    
    var incomingData = PFObject(className: "blogs")
    
    let blogPresentr = Presentr(presentationType: .fullScreen)
    
    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var blogLocation: UILabel!
    
    @IBOutlet var blogTitle: UILabel!
    
    @IBOutlet var blogBody: UILabel!
    
    @IBOutlet var blogTags: UILabel!
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    @IBOutlet var heartTabBarButton: UIBarButtonItem!
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var whiteBackgroundView: UIView!
    
    @IBAction func favouriteButton(_ sender: Any) {
        let blogID: String = incomingData.value(forKey: "objectId") as! String
        print("object Id = \(blogID)")
        var saveUser = PFUser.current()
        print("current user = \(saveUser)")
        var faves = Array<String>()
        faves.append(blogID)
        print("faves = \(faves)")
        saveUser?.setValue(faves, forKey: "faveBlogs")
        saveUser?.saveInBackground(block: { (done, error) in
            if error == nil {
                print("done updating blog into current user")
            }
        })
        
        
    }
    override func viewDidLoad() {
        heartTabBarButton.tintColor = retourStandards.retourGreen
        cancelButton.tintColor = retourStandards.retourGreen
        // backgroundView.backgroundColor = retourStandards.retourGrey
        backgroundView.backgroundColor = UIColor.lightGray
        whiteBackgroundView.layer.cornerRadius = 10
        whiteBackgroundView.layer.masksToBounds = true
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        titleImageView.image = UIImage(named: "newticketlogo44.png")
        titleImageView.contentMode = .scaleToFill
        navigationItem.titleView = titleImageView
        self.navBar.topItem?.titleView = titleImageView
        
        userImage.layer.cornerRadius = (userImage.frame.height) / 2
        userImage.clipsToBounds = true
        userImage.layer.borderWidth = 3
        userImage.layer.borderColor = UIColor.white.cgColor
        
      print("incoming - \(incomingData)")
        let incomingUser = incomingData.value(forKey: "userPoint") as! PFObject
        print("incoming user = \(incomingUser)")
        incomingUser.fetchIfNeededInBackground { (userobject, error) in
            print(userobject)
        
            // get the user image here...
            if incomingUser.value(forKey: "userImage") != nil {
                //    let userImage = UIImage(data: imageData)
                print("user image exists")
                let userimage = incomingUser.value(forKey: "userImage") as! PFFile
                userimage.getDataInBackground(block: { (data, error) in
                    if error == nil {
                        let finalImage: UIImage = UIImage(data: data!)!
                        self.userImage.image = finalImage
                    }
                })
                
            } else {
                print("no user image exists")
                self.userImage.image = UIImage(named: "userButton")
            }
            
            self.userName.text = userobject?.value(forKey: "username2") as! String
            self.blogBody.text = self.incomingData.value(forKey: "body") as! String
            self.blogTitle.text = self.incomingData.value(forKey: "title") as! String
            self.blogLocation.text = self.incomingData.value(forKey: "GMSPlaceQuickName") as! String
            
            if self.incomingData.value(forKey: "tags") != nil {
                self.blogTags.text = self.incomingData.value(forKey: "tags") as! String
            }
        }
        
        
    }
    
}
