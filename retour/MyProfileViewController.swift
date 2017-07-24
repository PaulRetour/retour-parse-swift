//
//  RegistrationViewController.swift
//  retour
//
//  Created by Paul Lancashire on 23/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ReachabilitySwift
import ImagePicker

class MyProfileViewController: UIViewController, ImagePickerDelegate {
    
    let reach = Reachability()
    
    let retourStandard = standards()
    
    @IBOutlet var cancelButtonOutlet: UIBarButtonItem!
    @IBOutlet var colourAndStampVIew: UIView!
    
    @IBOutlet var userImageView: UIImageView!
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        PFUser.logOut()
        print("logout button")
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func changeImage(_ sender: Any) {
        let picker = ImagePickerController()
        picker.imageLimit = 1
        picker.delegate = self
        present(picker, animated: true) { 
            
        }
        
    }
    @IBOutlet var NavBar: UINavigationBar!
    
    override func viewDidLoad() {
    
        colourAndStampVIew.backgroundColor = UIColor(patternImage: UIImage(named: "travel_stamps_detail.jpg")!)
        cancelButtonOutlet.tintColor = retourStandard.retourGreen
      //  colourAndStampVIew.backgroundColor = retourStandard.retourGreen
        getUserInfo()
        userImageView.layer.cornerRadius = (userImageView.frame.height) / 2
        userImageView.clipsToBounds = true
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.borderWidth = 3
        
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        titleImageView.image = UIImage(named: "newticketlogo44.png")
        titleImageView.contentMode = .scaleToFill
        navigationItem.titleView = titleImageView
        self.NavBar.topItem?.titleView = titleImageView
        

    }

    @IBOutlet var usernameField: UITextField!
    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var homeLocationFields: UITextField!
    
    
    @IBOutlet var hobbiesField: UITextField!
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        saveEverything()
        
    }
    func getUserInfo() {
        var user = PFUser.current()
        print("userloggedin - \(user!)")
        if user?.value(forKey: "username2") != nil {
        usernameField.text = user?.value(forKey: "username2") as! String
        }
        if PFUser.current()?.value(forKey: "homeLocation") != nil {
            self.homeLocationFields.text = PFUser.current()?.value(forKey: "homeLocation") as! String
        }
        if PFUser.current()?.value(forKey: "userImage") != nil {
            let userimage = user?.value(forKey: "userImage") as! PFFile
            userimage.getDataInBackground(block: { (data, error) in
                if error == nil {
                    let finalImage: UIImage = UIImage(data: data!)!
                    self.userImageView.image = finalImage
                }
            })
        }
        if PFUser.current()?.value(forKey: "homeLocation") != nil {
            homeLocationFields.text = PFUser.current()?.value(forKey: "homeLocation") as! String
        }
        if PFUser.current()?.value(forKey: "email") != nil {
            emailField.text = PFUser.current()?.value(forKey: "email") as! String
        }
        if PFUser.current()?.value(forKey: "hobbies") != nil {
            hobbiesField.text = PFUser.current()?.value(forKey: "hobbies") as! String
        }
        
    }
    
    func saveEverything() {
        if (reach?.isReachable)! {
            
            let newImageData = UIImageJPEGRepresentation(userImageView.image!, 0.25) as! Data
            let imageDataUpload = PFFile(data: newImageData)
            PFUser.current()?.setObject(imageDataUpload, forKey: "userImage")
            PFUser.current()?.saveInBackground(block: { (success, error) in
                if error == nil {
                    print("image saved")
                    self.dismiss(animated: true, completion: { 
                        
                    })
                }
            })
            
            
        } else {
            print("no connection")
        }
    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.userImageView.image = images[0]
        self.dismiss(animated: true) { 
            print("done")
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
}
