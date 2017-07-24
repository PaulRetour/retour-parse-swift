//
//  MyBlogListViewController.swift
//  retour
//
//  Created by Paul Lancashire on 11/07/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Presentr

class MyBlogListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myBlogsResults = [PFObject]()
    
    let blogPresentr = Presentr(presentationType: .fullScreen)
    
    @IBOutlet var myBlogsTableView: UITableView!
    
    let myUserID = PFUser.current()?.objectId
    
    private let refreshTable = UIRefreshControl()
    
    func getMyBlogs() {
        print("getting blogs")
       let query = PFQuery(className: "blogs")

       // query.whereKey("userPoint", equalTo: myUserID)
        
        query.findObjectsInBackground { (object, error) in

            print("completed query")
            if error == nil {
                print("here are the objects \(object?.count)")
                print(object)
                self.myBlogsResults = object!
                self.myBlogsTableView.reloadData()
            } else { print(error) }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getMyBlogs()
    }
    
    override func viewDidLoad() {

        let nib = UINib(nibName: "MyBlogsTableViewCell", bundle: nil)
        myBlogsTableView.register(nib, forCellReuseIdentifier: "MyBlogsTableViewCell")
        myBlogsTableView.refreshControl = refreshTable
        myBlogsTableView.rowHeight = 300
        myBlogsTableView.estimatedRowHeight = 500
        
        super.viewDidLoad()
        myBlogsTableView.delegate = self
        myBlogsTableView.dataSource = self
        getMyBlogs()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count = \(myBlogsResults.count)")
        return myBlogsResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBlogsTableViewCell", for: indexPath) as! MyBlogsTableViewCell
        let cellData = myBlogsResults[indexPath.row]
        print("celldata")
        print(cellData)
        cell.titleField.text = cellData.value(forKey: "title") as! String
        cell.bodyField.text = cellData.value(forKey: "body") as! String
        print("returning cell")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selectingrow")
        print(indexPath)
        let selectedData = myBlogsResults[indexPath.row] as! PFObject
        let blogView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
        blogView.incomingData = selectedData
        print("sent data")
        customPresentViewController(blogPresentr, viewController: blogView, animated: true) { 
            print("presented view")
        }
        
    }
}
