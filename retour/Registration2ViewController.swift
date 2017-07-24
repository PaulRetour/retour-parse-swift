//
//  Registration2ViewController.swift
//  retour
//
//  Created by Paul Lancashire on 24/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ReachabilitySwift
import JVFloatLabeledTextField

class Registration2ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let standardsInfo = standards()
    var reach = Reachability()!
    
    let dateFor = DateFormatter()
    
    var userToSave = PFUser()
    
    var strDate: String!
    
    let datePicker = UIDatePicker()
    let statusPicker = UIPickerView()
    
    let statusPickerData = ["Single", "Married", "Relationship"]
    let statusPickerTitle = ["Single", "Married", "Relationship"]
    
    @IBAction func dateChanged(sender: UIDatePicker) {
    }
    
    @IBAction func datePickerAction(_ sender: AnyObject) {
        
        
        let visualDateFormat = DateFormatter()
        dateFor.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        visualDateFormat.dateFormat = "dd'-'MM'-'yyyy'"
        strDate = dateFor.string(from: datePicker.date)
        let visualDate = visualDateFormat.string(from: datePicker.date)
        self.DOBTextField.text = visualDate as! String
        
        //don't save the visual date - save the strDate

        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        userToSave.setValue(usernameTextField.text, forKey: "username2")
        userToSave.setValue(strDate, forKey: "birthday")
        userToSave.setValue(datePicker.date, forKey: "birthDate")
        userToSave.setValue(statusTextField.text, forKey: "status")
        userToSave.setValue(passwordField.text, forKey: "password")
        saveDetails()
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var statusTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var DOBTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet var passwordField: JVFloatLabeledTextField!
    
    override func viewDidLoad() {
        
        print("incoming user - \(userToSave)")
        
        datePicker.addTarget(self, action: #selector(datePickerAction(_:)), for: .valueChanged)
        
        self.hideKeyboardWhenTappedAround()
        
        statusPicker.dataSource = self
        statusPicker.delegate = self
        
        label.textColor = standardsInfo.retourGrey
        DOBTextField.inputView = datePicker
        statusTextField.inputView = statusPicker
        
        statusTextField.inputView = statusPicker
        datePicker.datePickerMode = .date
    }
    
    func saveDetails() {
        // need to check if all ok.....
        performSegue(withIdentifier: "reg2ToReg3Segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reg2ToReg3Segue" {
            
            let dst = segue.destination as! Registration3ViewController
            dst.userToSave = self.userToSave
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusPickerData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            statusTextField.text = statusPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusPickerTitle[row] as! String
    }
    
    
    
}
