//
//  ListViewController.swift
//  retour
//
//  Created by Paul Lancashire on 02/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Presentr

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var prefsPresentr = Presentr(presentationType: .fullScreen)
    
    var prefsVC = UIViewController()
    
    @IBOutlet var prefsButton: UIBarButtonItem!
    
    
    @IBAction func prefsButtonAction(_ sender: Any) {
        customPresentViewController(prefsPresentr, viewController:
        prefsVC, animated: true) {
            
        }
    }
    
    @IBAction func unwindCancelFromPrefs(sender: UIStoryboardSegue) {
        print("unwind")
    }
    
    @IBOutlet var navBar: UINavigationBar!
    

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        titleImageView.image = UIImage(named: "newticketlogo44.png")
        titleImageView.contentMode = .scaleToFill
        navigationItem.titleView = titleImageView
        self.navBar.topItem?.titleView = titleImageView
        
        prefsPresentr.transitionType = .coverHorizontalFromRight
        
        prefsVC = (self.storyboard?.instantiateViewController(withIdentifier: "PrefsViewController"))!

        
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

