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
import WSTagsField

class BlogPostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var numberOfImages: Int!
    
    var imagesToDisplay = [UIImage]()
    
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
    
    var alreadyInFaves: Bool?
   
    @IBOutlet var imageCollectionView: UICollectionView!
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    let fullScreenImagePresentr = Presentr(presentationType: .fullScreen)
    let fullScreenImageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FullScreenImageVC") as! FulLScreenImageVC
    
    @IBOutlet var heartTabBarButton: UIBarButtonItem!
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var whiteBackgroundView: UIView!
    
    @IBAction func favouriteButton(_ sender: Any) {
        if alreadyInFaves == false {
        let blogID: String = incomingData.value(forKey: "objectId") as! String
        var faves = Array<String>()
        print("object Id = \(blogID)")
        var saveUser = PFUser.current()!
        print("current user = \(saveUser)")
        if saveUser.object(forKey: "faveBlogs") != nil {
            print("fave exists")
        faves = saveUser.value(forKey: "faveBlogs") as! Array<String>
        faves.append(blogID)
        } else {
            print("faves not exist")
            faves.insert(blogID, at: 0)
        }

        print("faves = \(faves)")
        saveUser.setValue(faves, forKey: "faveBlogs")
        saveUser.saveInBackground(block: { (done, error) in
            if error == nil {
                print("done updating blog into current user")
            }
        })
        
    //  checkIfAlreadyFave()
        } else {
            
            print("already in favourites so remove here")
            var currentFaves: Array<String> = PFUser.current()?.value(forKey: "faveBlogs") as! Array<String>
            currentFaves = currentFaves.filter { !$0.contains(incomingData.objectId!) }
            print("fave blogs now - \(currentFaves)")
            PFUser.current()?.setValue(currentFaves, forKey: "faveBlogs")
            PFUser.current()?.saveInBackground(block: { (done, error) in
                if error == nil {
                    print("updated removing blogs from faves")
                }
            })
        }
    }
    
    
    override func viewDidLoad() {
        
        self.automaticallyAdjustsScrollViewInsets = false

        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        heartTabBarButton.tintColor = retourStandards.retourGreen
        
        checkIfAlreadyFave()

        cancelButton.tintColor = retourStandards.retourGreen
        // backgroundView.backgroundColor = retourStandards.retourGrey
        //backgroundView.backgroundColor = UIColor.lightGray
        backgroundView.backgroundColor?.withAlphaComponent(0.3)
        whiteBackgroundView.layer.cornerRadius = 2
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
        
        findAndAddImages()
    }
    
    func checkIfAlreadyFave(){
        
        if PFUser.current()?.value(forKey: "faveBlogs") != nil {
        let userFaves = PFUser.current()?.value(forKey: "faveBlogs") as! Array<String>
            if userFaves.contains(incomingData.objectId!) {
                print("already exists in array so changing colour")
                self.heartTabBarButton.tintColor = UIColor.red
                self.alreadyInFaves = true
            } else {
                print("doesnt exist in faves array")
                self.heartTabBarButton.tintColor = retourStandards.retourGrey
                self.alreadyInFaves = false
            }
        } else { print("faveblogs == nil")
            alreadyInFaves = false }
    }
    
    func findAndAddImages() {
        
        print("find and add images")

        var image1: UIImage?
        var image2: UIImage?
        var image3: UIImage?
        
        // Find the number of images... //
        if incomingData.object(forKey: "image2file") != nil {
            numberOfImages = 3
        } else if incomingData.object(forKey: "image1file") != nil {
            numberOfImages = 2
        } else if incomingData.object(forKey: "image0file") != nil {
            numberOfImages = 1
        } else {
            numberOfImages = 0
        }
        
        print("number of images - \(numberOfImages)")
        
        switch numberOfImages {
        case 3:
            print("3 images")
            let image3File = incomingData.value(forKey: "image2file") as! PFFile
            let image2File = incomingData.value(forKey: "image1file") as! PFFile
            let image1File = incomingData.value(forKey: "image0file") as! PFFile
            image3File.getDataInBackground(block: { (data, error) in
                if error == nil {
                    image3 = UIImage(data: data!)
                    self.imagesToDisplay.append(image3!)
                }
            })
            image2File.getDataInBackground(block: { (data, error) in
                if error == nil {
                    image2 = UIImage(data: data!)
                    self.imagesToDisplay.append(image2!)
                }
            })
            image1File.getDataInBackground(block: { (data, error) in
                if error == nil {
                    image1 = UIImage(data: data!)
                    self.imagesToDisplay.append(image1!)
                    self.imageCollectionView.reloadData()
                }
            })
            
            
        case 2:
            print("2 images")
            let image2File = incomingData.value(forKey: "image1file") as! PFFile
            let image1File = incomingData.value(forKey: "image0file") as! PFFile
            image2File.getDataInBackground(block: { (data, error) in
                if error == nil {
                    image2 = UIImage(data: data!)
                    self.imagesToDisplay.append(image2!)
                    self.imageCollectionView.reloadData()
                }
            })
            image1File.getDataInBackground(block: { (data, error) in
                if error == nil {
                    image1 = UIImage(data: data!)
                    self.imagesToDisplay.append(image1!)
                    self.imageCollectionView.reloadData()
                }
            })
            
        case 1:
            print("1 image")
            let image1File = incomingData.value(forKey: "image0file") as! PFFile
            image1File.getDataInBackground(block: { (data, error) in
                if error == nil {
                    image1 = UIImage(data: data!)
                    self.imagesToDisplay.append(image1!)
                    self.imageCollectionView.reloadData()
                    
                }
            })

        default:
            print("no images found or error")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        let imageCell = cell.viewWithTag(1) as! UIImageView
        imageCell.image = imagesToDisplay[indexPath.row]
        print("returning cell")
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of images = \(numberOfImages)")
        return numberOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selecting \(imagesToDisplay[indexPath.row])")
        let imageToShow: UIImage = imagesToDisplay[indexPath.row]
        self.fullScreenImageVC.incomingImage = imageToShow
        customPresentViewController(fullScreenImagePresentr, viewController: fullScreenImageVC, animated: true) { 
            
        }
    }
}
