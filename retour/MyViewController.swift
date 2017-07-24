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

    let slideMenu = Presentr(presentationType: .fullScreen)
 //   var menuVC = UIViewController()

    @IBOutlet var containerViewFavourites: UIView!
    
    @IBOutlet var containerViewMyList: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        print("view appeared")
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
        


    }
    
    func showMyList() {
        print("showmylist")
        containerViewMyList.isHidden = false
        containerViewFavourites.isHidden = true
        self.navigationItem.rightBarButtonItem?.title = "My Blogs"

    }
    
    
    func setChosenScreen(id: Int) {
        print("setchosenscreen")
        if id == 1 {
            showFavourites()
        }
        if id == 2 {
            showMyList()
        }
    }
}

