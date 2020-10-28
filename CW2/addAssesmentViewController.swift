//
//  addAssesmentViewController.swift
//  CW2
//
//  Created by Anton Samuilov on 16/05/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class addAssesmentViewController: UIViewController,UITextFieldDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var moduleNameTextFields: UITextField!
    @IBOutlet weak var level: UITextField!
    @IBOutlet weak var assesmentNameTextField: UITextField!
    @IBOutlet weak var valueOfAssesmentTextField: UITextField!
    @IBOutlet weak var acheivedMarkTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var callenderAdd: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SOGetPermissionCalendarAccess()
        valueOfAssesmentTextField.delegate = self
        acheivedMarkTextField.delegate = self
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 2
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    static func checkForCharacters (value: UITextField,marks: UITextField,textFieldLevel: UITextField, completion: @escaping ((_ bool: Bool?)->())){
        //let char = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        let value =  value.text
        let marks = marks.text
        let level = textFieldLevel.text
        if (value!.rangeOfCharacter(from: CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")) != nil) ||  (marks!.rangeOfCharacter(from: CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")) != nil) ||  (level!.rangeOfCharacter(from: CharacterSet(charactersIn: "12890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")) != nil){
            completion(false)
        }else{
            completion(true)
        }
    }
    
    func SOGetPermissionCalendarAccess() {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
            
        case .authorized:
            print("Authorized")
            
        case .denied:
            print("Access denied")
            
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion:
                {(granted: Bool, error: Error?) -> Void in
                    if granted {
                        print("Access granted")
                    } else {
                        print("Access denied")
                    }
            })
            
            print("Not Determined")
        default:
            print("Case Default")
        }
    }
    
    
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if moduleNameTextFields.text == "" || assesmentNameTextField.text == "" || valueOfAssesmentTextField.text == "" || acheivedMarkTextField.text == ""  || notesTextField.text == "" {
            let alert = UIAlertController(title: "Something went wrong", message: "Module Name, Assesment Name, Value of Assesment or Acheived Marks must not be empty", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else{
            let newAssesment = Assesment(context: self.context)
            
            addAssesmentViewController.checkForCharacters (value: self.acheivedMarkTextField, marks: self.valueOfAssesmentTextField ,textFieldLevel: level) { bool in
                print(bool!)
                if bool! == false{
                    let alert = UIAlertController(title: "Something went wrong", message: "Assesment value % and Acheived Marks must be an numerical value and Level must be between 3 and 7", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                else if bool! == true{
                    //let newAssesment = Assesment(context: self.context)
                    let marks = self.acheivedMarkTextField.text!
                    newAssesment.markAwarded = Double(marks)!
                    
                    let value = self.valueOfAssesmentTextField.text!
                    newAssesment.value = Double(value)!
                    newAssesment.assesmentName = self.assesmentNameTextField.text
                    newAssesment.moduleName = self.moduleNameTextFields.text
                    newAssesment.dueDate = self.dueDatePicker.date
                    newAssesment.notes = self.notesTextField.text
                    if let level = self.level.text{
                        newAssesment.level = Int64(level)!
                    }
                    //newAssesment.level = Int64(level.text)
                    let date = Date()
                    newAssesment.todayDate = date
                    
                    if self.callenderAdd.isOn == true
                    {
                        addToCalendar.callenderTitle(assesmentName: self.assesmentNameTextField.text!, dueDate: self.dueDatePicker.date, notes: self.notesTextField.text!, completion: { (success) -> Void in
                            if success != "notAdded" {
                                
                                newAssesment.eventID = success
                                DispatchQueue.main.async {
                                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                }
                            } else if success == "error"{
                                DispatchQueue.main.async {
                                   let alert = UIAlertController(title: "Something went wrong", message: "The start date must be before the end date", preferredStyle: .alert)
                                   let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                   alert.addAction(action)
                                   self.present(alert, animated: true, completion: nil)
                                }
                                
                            } else {
                                newAssesment.eventID = success
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                
                            }
                        })
                    }else if self.callenderAdd.isOn == false
                    {
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        
                    }
                }
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            }
        }
    }
}
