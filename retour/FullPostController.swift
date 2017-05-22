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

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func save(_ sender: Any) {
    saveData()
    }
    
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    @IBAction func pingButtonAction(_ sender: Any) {
    }
    
    
    var imagesArray = [UIImage]()
    
    var objectToSave: PFObject!
    
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
    
    @IBAction func photosButton(_ sender: Any) {
        
    present(imagePickerController, animated: true, completion: nil)
        
    }
    let retourGreen = UIColor(red:0.58, green:0.82, blue:0.76, alpha:1.0)
    let retourGrey = UIColor(red: 0.79, green: 0.79, blue: 0.78, alpha: 1.0)
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
        
    override func viewDidLoad() {
        
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
    
    func saveData() {
        
        alertPopUp = storyboard?.instantiateViewController(withIdentifier: "alert1VC") as! Alert1ViewController
        print("existing data - \(objectToSave)")
        print("object to save")
        print(objectToSave)
        if titleText.text != nil || titleText.text != "Title" { objectToSave.setValue(titleText.text, forKey: "title") }
        if bodyText.text != nil { objectToSave.setValue(bodyText.text, forKey: "body") }
        if tagsText.text != nil { objectToSave.setValue(tagsText.text, forKey: "tags") }
        if imagesArray.count > 0 { for i in imagesArray {
            // set each image to data
            // then save to image[indexPath]file //
            }} else { print("no images") }

        objectToSave.saveInBackground { (success, error) in
            if (success) {
                print("object saved")
            } else { print(error?.localizedDescription)
                let presentAlert = Presentr(presentationType: .alert)
                self.customPresentViewController(presentAlert, viewController: self.alertPopUp, animated: true, completion: {
                    
                })
                print("not saved")
        }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("pressed image number \(indexPath)")
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

