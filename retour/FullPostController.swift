//
//  FullPostController.swift
//  retour
//
//  Created by Paul Lancashire on 12/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import ImagePicker
import Parse
import IHKeyboardAvoiding
import Presentr


class FullPostController: UIViewController, UITextViewDelegate, UITextFieldDelegate, ImagePickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var alertPopUp = UIViewController()
    
    var savingPopUp = UIViewController()

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func save(_ sender: Any) {
    saveData()
    }
    
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    @IBAction func pingButtonAction(_ sender: Any) {
    }
    
    
    var imagesArray = [UIImage]()
    
    var objectToSave: PFObject! {
        didSet {
            print("updated object - \(objectToSave)")
        }
    }
    
    var placeToSave: PFObject! {
        didSet {
            print("updated place - \(placeToSave)")
        }
    }
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!

    @IBAction func cancelButton(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var cancelButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var placeAddressLabel: UILabel!
    
    @IBOutlet weak var bodyText: UITextView!
    
    @IBOutlet weak var tagsText: UITextField!
    
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    let imagePickerController = ImagePickerController()
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var titleBar: UIView!
    
    @IBOutlet weak var bodyBar: UIView!
    
    @IBOutlet weak var tagBar: UIView!
    @IBOutlet weak var photosBar: UIView!
    
    
    @IBAction func storeButton(_ sender: Any) {
        pinData()
    }
    
    @IBAction func photosButton(_ sender: Any) {
        
    present(imagePickerController, animated: true, completion: nil)
        
    }
    let retourGreen = UIColor(red:0.58, green:0.82, blue:0.76, alpha:1.0)
    let retourGrey = UIColor(red: 0.79, green: 0.79, blue: 0.78, alpha: 1.0)
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
        
    override func viewDidLoad() {
        
        print("incoming object - \(objectToSave)")
        print("incoming place - \(placeToSave)")
        
        self.hideKeyboardWhenTappedAround()
        KeyboardAvoiding.avoidingView = self.titleText
        KeyboardAvoiding.avoidingView = self.bodyText
        KeyboardAvoiding.avoidingView = self.tagsText
        
        super.viewDidLoad()
    //    self.hideKeyboardWhenTappedAround()
        
        imagePickerController.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        imagesCollectionView.allowsSelection = true
        imagePickerController.imageLimit = 3
        
        bodyText.delegate = self
        tagsText.delegate = self
        titleText.delegate = self
        
        topBar.layer.cornerRadius = 5
        titleBar.layer.cornerRadius = 5
        bodyBar.layer.cornerRadius = 5
        tagBar.layer.cornerRadius = 5
        photosBar.layer.cornerRadius = 5
    
        cancelButtonOutlet.tintColor = UIColor.white
        saveButtonOutlet.tintColor = UIColor.white
        navBar.backgroundColor = retourGreen
        
        self.view.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        titleText.backgroundColor = UIColor.white
        
        self.imagesCollectionView!.register(UINib(nibName: "NewPostImagesXib", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
        textField.text = ""
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapper pressed")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("done button pressed")
        print("\(images.count) images returned")
        if images.count != 0 { self.imagesArray = images
        print("images array updated")
        print(imagesArray.count)}
        imagePicker.dismiss(animated: true, completion: nil)
        self.imagesCollectionView.reloadData()
        }

    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("cancelling")
        imagePicker.dismiss(animated: true) { 
            print("dismissed")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! NewPostImagesXib
        let imageforCell = self.imagesArray[indexPath.row] as! UIImage
        cell.mainImage.image = imageforCell
        return cell
    }
    
    func pinData() {
        
        var imageNumberSaved = 0
        let acl = PFACL()
        acl.getPublicReadAccess = true
        acl.setWriteAccess(true, for: PFUser.current()!)
        objectToSave.acl = acl
        objectToSave.setValue(PFUser.current(), forKey: "userPoint")
        // objectToSave.setValue(self.typesdict, forKey: "types_array")
        
        alertPopUp = storyboard?.instantiateViewController(withIdentifier: "alert1VC") as! Alert1ViewController
        savingPopUp = storyboard?.instantiateViewController(withIdentifier: "savingVC") as! SavingViewController
        
        let present = Presentr(presentationType: .alert)
        self.customPresentViewController(present, viewController: savingPopUp, animated: true) {
            
        }
        
        print("existing data - \(objectToSave)")
        print("object to save")
        if titleText.text != nil || titleText.text != "Title" { objectToSave.setValue(titleText.text, forKey: "title") }
        if bodyText.text != nil { objectToSave.setValue(bodyText.text, forKey: "body") }
        if tagsText.text != nil { objectToSave.setValue(tagsText.text, forKey: "tags") }
        
        if imagesArray.count > 0 {
            
            for i in imagesArray {
                
                // set each image to data
                // then save to image[indexPath]file //
                
                // returns image as data representation and prepares pffile
                let newImageData = UIImageJPEGRepresentation(i, 0.25) as! Data
                let imageDataUpload = PFFile(data: newImageData)
                
                let id = imagesArray.index(of: i) as! Int
                
                objectToSave.setValue(imageDataUpload, forKey: "image\(id)file")
                
                imageDataUpload?.saveInBackground(block: { (complete, err) in
                    if err == nil {
                        print("complete")
                        imageNumberSaved = imageNumberSaved + 1
                        print("image number saved = \(imageNumberSaved)")
                        if imageNumberSaved == self.imagesArray.count {
                            print("about to save.... object = \(self.objectToSave)")
                            
                            self.objectToSave.pinInBackground(block: { (done, error) in
                            print("pinning")
                          //  self.objectToSave.saveInBackground(block: { (done, err) in
                                print("finally saved all images")
                                self.savingPopUp.dismiss(animated: true, completion: {
                                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                                        print("current vc = \(self.nibName)")
                                    })
                                })
                                // check here for existing place - if not, add this new one //
                                var placeQuery = PFQuery(className: "places")
                                placeQuery.whereKey("GMSPlaceID", contains: self.placeToSave.value(forKey: "GMSPlaceID") as! String)
                                placeQuery.findObjectsInBackground(block: { (object, err) in
                                    if err == nil {
                                        print("no error")
                                        if object?.count == 0 {
                                            print("no existing object")
                                            self.placeToSave.saveEventually()
                                        }
                                    } else { print("error finding place") }
                                })
                                
                            })
                        }
                    } else { print("handle image error here") }
                })
            }
            
        } else {
            // This does the saving and dismissing if no images present...
            // need to add in the place saving part too
            print("no images")
            

            //objectToSave.saveEventually()
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: { 
                print("dismissing")
            })
            objectToSave.pinInBackground(block: { (success, error) in
                print("pinning")
                if (success) {
                    print("object saved")
                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: {
                        
                    })
                } else { print(error?.localizedDescription)
                    let presentAlert = Presentr(presentationType: .alert)
                    self.customPresentViewController(presentAlert, viewController: self.alertPopUp, animated: true, completion: {
                        
                    })
                    print("not saved")
                    print(error)
                }
            })
        }
    }
    
    func saveData() {
        
        var imageNumberSaved = 0
        let acl = PFACL()
        acl.getPublicReadAccess = true
        acl.setWriteAccess(true, for: PFUser.current()!)
        objectToSave.acl = acl
        objectToSave.setValue(PFUser.current(), forKey: "userPoint")
       // objectToSave.setValue(self.typesdict, forKey: "types_array")
        
        alertPopUp = storyboard?.instantiateViewController(withIdentifier: "alert1VC") as! Alert1ViewController
        savingPopUp = storyboard?.instantiateViewController(withIdentifier: "savingVC") as! SavingViewController
        
        let present = Presentr(presentationType: .alert)
        self.customPresentViewController(present, viewController: savingPopUp, animated: true) { 
            
        }
        
        print("existing data - \(objectToSave)")
        print("object to save")
        if titleText.text != nil || titleText.text != "Title" { objectToSave.setValue(titleText.text, forKey: "title") }
        if bodyText.text != nil { objectToSave.setValue(bodyText.text, forKey: "body") }
        if tagsText.text != nil { objectToSave.setValue(tagsText.text, forKey: "tags") }

        if imagesArray.count > 0 {
            
            for i in imagesArray {
            
            // set each image to data
            // then save to image[indexPath]file //
            
            // returns image as data representation and prepares pffile
            let newImageData = UIImageJPEGRepresentation(i, 0.25) as! Data
            let imageDataUpload = PFFile(data: newImageData)
            
            let id = imagesArray.index(of: i) as! Int
                
            objectToSave.setValue(imageDataUpload, forKey: "image\(id)file")
            
            imageDataUpload?.saveInBackground(block: { (complete, err) in
                if err == nil {
                    print("complete")
                    imageNumberSaved = imageNumberSaved + 1
                    print("image number saved = \(imageNumberSaved)")
                    if imageNumberSaved == self.imagesArray.count {
                        print("about to save.... object = \(self.objectToSave)")
                        self.objectToSave.saveInBackground(block: { (done, err) in
                            print("finally saved all images")
                            self.savingPopUp.dismiss(animated: true, completion: {
                                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                                   print("current vc = \(self.nibName)")
                                })
                            })
                            // check here for existing place - if not, add this new one //
                            var placeQuery = PFQuery(className: "places")
                            placeQuery.whereKey("GMSPlaceID", contains: self.placeToSave.value(forKey: "GMSPlaceID") as! String)
                            placeQuery.findObjectsInBackground(block: { (object, err) in
                                if err == nil {
                                    print("no error")
                                    if object?.count == 0 {
                                        print("no existing object")
                                        self.placeToSave.saveEventually()
                                    }
                                } else { print("error finding place") }
                            })
                
                        })
                    }
                } else { print("handle image error here") }
            })
            }
            
        } else { print("no images")
            
            objectToSave.saveInBackground { (success, error) in
                // objectToSave.saveEventually { (success, error) in
                
                if (success) {
                    print("object saved")
                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: {
                        
                    })
                } else { print(error?.localizedDescription)
                    let presentAlert = Presentr(presentationType: .alert)
                    self.customPresentViewController(presentAlert, viewController: self.alertPopUp, animated: true, completion: {
                        
                    })
                    print("not saved")
                    print(error)
                }
            }
        
        }



    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("pressed image number \(indexPath)")
    }
    
    func imageToData(image: UIImage) -> NSData {
        
        let outputData = NSData()
        
        return outputData
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func yourTextView(textView: UITextView!, shouldChangeTextInRange: NSRange, replacementText: NSString!) -> Bool {
        if (replacementText == "\n")  {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

