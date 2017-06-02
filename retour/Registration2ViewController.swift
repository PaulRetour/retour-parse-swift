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
    
    let datePicker = UIDatePicker()
    let statusPicker = UIPickerView()
    
    let statusPickerData = ["Single", "Married", "Relationship"]
    let statusPickerTitle = ["Single", "Married", "Relationship"]
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        self.DOBTextField.text = datePicker.date as! String
    }
    

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var statusTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var DOBTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        
        self.hideKeyboardWhenTappedAround()
        
        statusPicker.dataSource = self
        
        label.textColor = standardsInfo.retourGrey
        DOBTextField.inputView = datePicker
        statusTextField.inputView = statusPicker
        
        statusTextField.inputView = statusPicker
        datePicker.datePickerMode = .date
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
        print(statusPickerTitle[row] as! String)
        return statusPickerTitle[row] as! String
    }
    
    
    
}
