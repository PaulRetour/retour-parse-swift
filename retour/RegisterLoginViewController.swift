//
//  RegisterLoginViewController.swift
//
//
//  Created by Paul Lancashire on 05/04/2017.
//  Copyright © 2017 Yuji Hato. All rights reserved.
//

import Foundation
import UIKit
import ParseFacebookUtilsV4
import Parse
import Alamofire

class RegisterLoginViewController: UIViewController {
    
    var fbGraphUpdater = PFObject(className: "User")
    
    override func viewDidLoad() {
        print("login controller - perform all here and dismiss if required")
    }
    
    @IBAction func loginWithFBButton(sender: AnyObject) {
        
        let permissions: NSArray = ["public_profile", "email", "user_friends", "user_birthday", "user_likes", "user_relationships"]
        
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions as? [String]) { (user, error) in
            
            print("attempting fb login")
            
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                    // need to grab the user info and stick it in the UserDefaults table
                    // also need the user image from fb... or add standard image
                    
                    self.fbGraphRequestAll()
                    print("signedup and logged in - dismissing view controller")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("User logged in through Facebook!")
                    self.fbGraphRequestAll()
                    // need to grab the user info and stick it in the UserDefaults table
                    // also need the user image from fb... or add standard image
                    print("logged in through facebook - dismissing view controller")
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
        
    }
    
    func fbGraphRequestAll() {
        
        var parseDateStyle = DateFormatter()
        parseDateStyle.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        
        var imageURL : String!
        
        print("FB Login - Requesting User Data")
        let graphRequest = FBSDKGraphRequest(graphPath: "me/", parameters: ["fields": "id, name, email, birthday, likes, relationship_status, picture.type(normal)"])
        graphRequest?.start(completionHandler: { (connection, resulta,error) -> Void in
            
            var result = resulta as! NSDictionary
            if error == nil {
                print("facebook info - \(result)")
                var fbPictureInfo = result.value(forKey: "picture") as! NSDictionary
                var fbPictureData = fbPictureInfo.value(forKey: "data") as! NSDictionary
                imageURL = fbPictureData.value(forKey: "url") as! String
                let userName: String = result.value(forKey: "name") as! String
                let birthday: String = result.value(forKey: "birthday") as! String
                
                let fbDateFormat = DateFormatter()
                fbDateFormat.dateFormat = "dd/MM/yyyy"
                let fbToDate: Date = fbDateFormat.date(from: birthday)!
                let outputDateString: String = parseDateStyle.string(from: fbToDate)
                print("date string to save = \(outputDateString)")
                print("date = \(fbToDate)")
                
                let email: String = result.value(forKey: "email") as! String
                let status: String = result.value(forKey: "relationship_status") as! String
                PFUser.current()!.setValue(userName, forKey: "username2")
                PFUser.current()!.setValue(outputDateString, forKey: "birthday")
                PFUser.current()?.setValue(fbToDate, forKey: "birthDate")
               // PFUser.current()?.setValue(fbToDate, forKey: "birthDate")
                PFUser.current()!.setValue(email, forKey: "email")
                PFUser.current()?.setValue(email, forKey: "username")
                PFUser.current()?.setValue(status, forKey: "status")
            //    PFUser.current()?.saveEventually()
                PFUser.current()?.saveInBackground(block: { (complete, error) in
                    print("done saving")
                })
             //   print("saving facebook info")
                
                //  once complete above, get image
                
                Alamofire.request(imageURL).response { response in
                    
                    if response.error == nil {
                        
                        print("image retrieved as nsdata")
                        let saveImageData = response.data
                        let uploadFile = PFFile(data: saveImageData!)
                        PFUser.current()?.setValue(uploadFile, forKey: "userImage")
                        PFUser.current()?.saveInBackground(block: { (bool, err) -> Void in
                            if err == nil {
                                print("done saving user image")
                            }
                        })
                        
                    } else { print("alam image err") }
                    
                }
            }
        })
        
    }
    
}
