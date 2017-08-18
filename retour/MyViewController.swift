//
//  MyViewController.swift
//  retour
//
//  Created by Paul Lancashire on 09/07/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Presentr

class MyViewController: UIViewController, MyMenuVCDelegate {
    
    // 1 = favourites, 2 = my blogs, 3 = my trips
    var chosenScreen: Int = 1 {
        didSet {
            print("changed")
        }
    }
    
    let presenter = Presentr(presentationType: .topHalf)
    
    let colours = standards()

    let slideMenu = Presentr(presentationType: .fullScreen)

    @IBOutlet var viewButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
 //   var menuVC = UIViewController()

    @IBOutlet var containerViewFavourites: UIView!
    
    @IBOutlet var containerViewMyList: UIView!
    
    @IBOutlet var containerViewOffline: UIView!
    
    @IBOutlet var containerViewTrips: UIView!
    // Depending upon view, use add to create.. e.g. new trip!
    // or hide otherwise..
    @IBAction func addButton(_ sender: Any) {
        print("addButton \(chosenScreen)")
        if chosenScreen == 4 {
            print("offline add button")
            let AddVC = storyboard?.instantiateViewController(withIdentifier: "AddTripViewController")
            customPresentViewController(presenter, viewController: AddVC!, animated: true, completion: { 
                
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view appeared")
    //    slideMenu.presentationType = .custom(width: ModalSize.custom(size: (UIScreen.main.bounds.width / 2)), height: ModalSize.full, center: ModalCenterPosition.custom(centerPoint: CGPoint(x: (UIScreen.main.bounds.width / 2)), y: (UIScreen.main.bounds.height / 2)))
        slideMenu.presentationType = .custom(width: ModalSize.custom(size: 300), height: ModalSize.full, center: ModalCenterPosition.custom(centerPoint: CGPoint(x: 300, y: (UIScreen.main.bounds.height / 2))))
    }
    
    @IBAction func showMenu(_ sender: Any) {
        
        print("menu here")
        slideMenu.transitionType = TransitionType.coverHorizontalFromRight
        let menuVC = (self.storyboard?.instantiateViewController(withIdentifier: "myMenuVC"))! as! MyMenuVC
        menuVC.delegate = self
        customPresentViewController(slideMenu, viewController: menuVC, animated: true, completion: nil)
    }
    
    @IBOutlet var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        viewButton.tintColor = colours.retourGreen
        showFavourites()
        super.viewDidLoad()
      //  menuVC.delegate = self
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        titleImageView.image = UIImage(named: "newticketlogo44.png")
        titleImageView.contentMode = .scaleToFill
        navigationItem.titleView = titleImageView
        self.navBar.topItem?.titleView = titleImageView
    }
    
    func showFavourites() {
        print("showfavourites")
        containerViewFavourites.isHidden = false
        containerViewMyList.isHidden = true
        containerViewOffline.isHidden = true
        containerViewTrips.isHidden = true
        containerViewFavourites.reloadInputViews()
        addButton.tintColor = UIColor.white
        viewButton.title = "Favourites"


    }
    
    func showMyList() {
        print("showmylist")
        containerViewMyList.isHidden = false
        containerViewFavourites.isHidden = true
        containerViewOffline.isHidden = true
        containerViewTrips.isHidden = true
        addButton.tintColor = UIColor.white
        viewButton.title = "My Blogs"

    }
    
    func showOffline() {
        print("show offlinelist")
        containerViewMyList.isHidden = true
        containerViewFavourites.isHidden = true
        containerViewOffline.isHidden = false
        containerViewTrips.isHidden = true
        addButton.tintColor = colours.retourGreen
        viewButton.title = "Offline"
        
    }
    
    func showTrips() {
        print("show trips")
        containerViewMyList.isHidden = true
        containerViewFavourites.isHidden = true
        containerViewOffline.isHidden = true
        containerViewTrips.isHidden = false
        viewButton.title = "Trips"
        addButton.tintColor = colours.retourGreen
        
    }
    
    
    func setChosenScreen(id: Int) {
        print("setchosenscreen")
        if id == 1 {
            showFavourites()
            chosenScreen = 1
        }
        if id == 2 {
            showMyList()
            chosenScreen = 2
        }
        
        if id == 3 {
            showOffline()
            chosenScreen = 3
        }
        
        if id == 4 {
            showTrips()
            chosenScreen = 4
        }
    }
}

