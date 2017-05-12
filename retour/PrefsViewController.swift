//
//  PrefsViewController.swift
//  retour
//
//  Created by Paul Lancashire on 02/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
class PrefsViewControoler: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        searchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("editing search text")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        performSegue(withIdentifier: "unwindCancelFromPrefsWithSender", sender: self)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" { print("search text is \(searchBar.text)") }
    }
    @IBAction func searchButton(_ sender: Any) {
        if searchBar.text != "" { print("search text is \(searchBar.text)") }
        performSegue(withIdentifier: "unwindSaveFromPrefsWithSender", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Do the save stuff here //
        if segue.identifier == "unwindSaveFromPrefsWithSender" {
            print("prepare here")
        }
        
    }
    
}
