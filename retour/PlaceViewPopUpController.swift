//
//  PlaceViewPopUpController.swift
//  retour
//
//  Created by Paul Lancashire on 21/06/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Presentr

class PlaceViewPopUpController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {
    
    var incomingData = [PFObject]()
    
    var RStandard = standards()
    
    let blogPresentr = Presentr(presentationType: .fullScreen)
    
    let customBlogPresentr: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 50)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
     
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
       
        return customPresenter
    }()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        print("loading controller")
        print(incomingData)
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.alpha = 0.6
        
        self.collectionView!.register(UINib(nibName: "PopUpSearchResultsCell", bundle: nil), forCellWithReuseIdentifier: "PopUpSearchResultsCell")
       // collectionView.reloadData()
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        incomingData.count
        print("incoming count - \(incomingData.count)")
        return incomingData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Setup the cell in here //
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopUpSearchResultsCell", for: indexPath) as! PopUpSearchResultsCell
        let title = incomingData[indexPath.row].value(forKey: "title") as! String
        var userDetails = incomingData[indexPath.row].object(forKey: "userPoint") as! PFObject
        //cell.layer.cornerRadius =
       // collectionView.bounds.height = self.view.bounds.height
       // collectionView.backgroundColor = RStandard.retourGreen
        collectionView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.lightText.cgColor
        
        cell.userImage.layer.cornerRadius = (cell.userImage.bounds.height / 2)
        cell.userImage.layer.masksToBounds = true
        
        cell.layer.borderWidth = 1
        cell.titleLabel.text = title
        cell.testLable.text = userDetails.value(forKey: "username2") as! String
        cell.locationLabel.text = incomingData[indexPath.row].value(forKey: "GMSPlaceQuickName") as! String
        cell.mainBodyLabel.text = incomingData[indexPath.row].value(forKey: "body") as! String

        // check for userimage, and download it, otherwise put stock one //
        if userDetails.value(forKey: "userImage") != nil {
    //    let userImage = UIImage(data: imageData)
            print("user image exists")
            let userimage = userDetails.value(forKey: "userImage") as! PFFile
            userimage.getDataInBackground(block: { (data, error) in
                if error == nil {
                    let finalImage: UIImage = UIImage(data: data!)!
                    cell.userImage.image = finalImage
                }
            })
        
        } else {
            print("no user image exists")
            cell.userImage.image = UIImage(named: "userButton")
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected \(indexPath)")
        print(incomingData[indexPath.row])
        let selectedData = incomingData[indexPath.row] as! PFObject
        let blogView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
        blogView.incomingData = selectedData
        customPresentViewController(blogPresentr, viewController: blogView, animated: true) {
            print("presented view")
        }
        
    }
}
