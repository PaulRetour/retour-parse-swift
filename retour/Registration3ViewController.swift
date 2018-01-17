//
//  Registration3ViewController.swift
//  retour
//
//  Created by Paul Lancashire on 12/06/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ImagePicker

class Registration3ViewController: UIViewController, ImagePickerDelegate {
    
    let profileImagePicker = ImagePickerController()
    var userToSave = PFUser()
    
    var imageData = Data()

    @IBOutlet weak var spinner: InstagramActivityIndicator!

    @IBAction func save(_ sender: Any) {
        print("save here")
        finishSignUp()
    }
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        spinner.isHidden = true
        
        saveButton.isHidden = true
        userImage.backgroundColor = UIColor.gray
        userImage.layer.cornerRadius = 40
        profileImagePicker.delegate = self
        profileImagePicker.imageLimit = 1
        print("incoming user - \(userToSave)")
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.tap(sender:)))
        userImage.addGestureRecognizer(tapImage)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.userImage.image = images[0]
        
        dismiss(animated: true) { 
            self.saveButton.isHidden = false
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
        userImage.image = nil
        profileImagePicker.dismiss(animated: true) {
            self.saveButton.isHidden = false
        }
        self.saveButton.isHidden = false
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
   func tap(sender: UITapGestureRecognizer) {
        print("tap here")
    present(profileImagePicker, animated:
        true, completion: nil )
    }
    
    
    func finishSignUp() {
        
        spinner.isHidden = false
        
        
        // if image exists....
        if userImage.image != nil {
        imageData = UIImageJPEGRepresentation(self.userImage.image!, 0.5)!
        let uploadData = PFFile(data: self.imageData)
        
        uploadData?.saveInBackground(block: { (done, error) in
            if error == nil {
                self.userToSave.setValue(uploadData, forKey: "userImage")
                print("uploading image")
                self.spinner.isHidden = true
                
//                self.userToSave.saveInBackground(block: { (done, error) in
//                    if error == nil {
//                        print("saved")
//                    }
//                })
                
                self.userToSave.signUpInBackground(block: { (done, error) in
                    if error == nil {
                        
                        if self.userToSave.value(forKey: "emailVerified") as! Bool == true {
                            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: { 
                                print("verified so dismissing all back to home")
                            })
                        } else {
                            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                                print("not verified so dismissing back to login screen")
                            })
                        }
                        
                        
                        
                    }
                })
                
            } else {print("error saving")
            print(error?.localizedDescription)}
        })

        }
        
        // if no images exists
            
        else {
            print("saving without iage")
            self.userToSave.signUpInBackground(block: { (done, error) in
                if error == nil {
                    print("done saving without images")
                    self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                        "dismissing views"
                    })
                } else { print(error) }
            })
        }
    }
}
