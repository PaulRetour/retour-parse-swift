//
//  AddTripViewController.swift
//  retour
//
//  Created by Paul Lancashire on 16/08/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Parse
import JVFloatLabeledTextField
import ImagePicker


class AddTripViewController: UIViewController, ImagePickerDelegate {
    
    let picker = ImagePickerController()
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet var imageButtonOutlet: UIImageView!
    @IBAction func addImageButton(_ sender: Any) {

        present(picker, animated: true, completion: nil)
    }
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var defaultTripImage: UIImageView!
    
    @IBOutlet var tripTitle: UITextField!
    
    @IBOutlet var tripDescription: UITextField!
    
    @IBAction func addButton(_ sender: Any) {
        print("add trip here...")
        var newTripObject = PFObject(className: "trips")
        newTripObject.setValue(tripTitle.text! as! String, forKey: "tripName")
        newTripObject.setValue(tripDescription.text! as! String,forKey: "tripDesc")
        newTripObject.setValue(PFUser.current(), forKey: "user")
        if imageView.image != nil {
            let newImageData = UIImageJPEGRepresentation(imageView.image!, 0.25) as! Data
            let imageDataUpload = PFFile(data: newImageData)
            newTripObject.setObject(imageDataUpload, forKey: "tripImage")
            imageDataUpload?.saveInBackground(block: { (done, err) in
                if err == nil {
                    print("image uploaded")
                }
            })
        }
        newTripObject.saveInBackground { (done, error) in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else { print("error \(error?.localizedDescription)") }
        }
    }
    @IBOutlet var addButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        picker.delegate = self
        picker.imageLimit = 1
        defaultTripImage.layer.cornerRadius = 5
        defaultTripImage.backgroundColor = UIColor.lightGray
        defaultTripImage.alpha = 0.5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if imageView.image != nil {
           imageButtonOutlet.isHidden = true

        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        picker.dismiss(animated: false) {
            print("done button")
            self.imageView.image = images[0]
            self.imageButtonOutlet.isHidden = true

        }
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
}
