//
//  editViewController.swift
//  CW2
//
//  Created by Anton Samuilov on 16/05/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class editAssesmentViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var valueOfAssesmen: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    
    @IBOutlet weak var moduleLevelTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var marksAcheived: UITextField!
    @IBOutlet weak var assesmentName: UITextField!
    @IBOutlet weak var moduleName: UITextField!
    @IBOutlet weak var calendarSwitch: UISwitch!
    
    @IBOutlet weak var level: UITextField!
    var assesment: Assesment!
    var eventID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.moduleLevelTextField.delegate = self
        //moduleLevelTextField.-
        
        
        let value = assesment?.value
        valueOfAssesmen.text = String(Int(value!))
        notes.text = assesment?.notes
        dueDate.date = (assesment?.dueDate)!
        let mark = assesment?.markAwarded
        marksAcheived.text = String(Int(mark!))
        moduleName.text = assesment?.moduleName
        assesmentName.text = assesment?.assesmentName
        if let level = assesment?.level{
            moduleLevelTextField.text = "\(String(describing: level))"
        }
        eventID = assesment.eventID
        if eventID == "notAdded"{
            
        }else if eventID == nil {
            
        }
        else{
            
            addToCalendar.deleteEvent(eventID)

        }
        notes.text = assesment.notes
        marksAcheived.delegate = self
        valueOfAssesmen.delegate  = self
        // Do any additional setup after loading the view.
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
    
    @IBAction func updatePressed(_ sender: Any) {
        if moduleName.text == "" || assesmentName.text == "" || valueOfAssesmen.text == "" || marksAcheived.text == ""  {
            let alert = UIAlertController(title: "Something went wrong", message: "Module Name, Assesment Name, Value of Assesment or Acheived Marks must not be empty", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
        else
        {
            addAssesmentViewController.checkForCharacters(value: marksAcheived, marks: marksAcheived, textFieldLevel: level)  { bool in
                if bool! == true {
                    let marks = self.marksAcheived.text!
                    self.assesment.markAwarded = Double(marks)!
                    
                    let value = self.valueOfAssesmen.text!
                    self.assesment.value = Double(value)!
                    self.assesment.assesmentName = self.assesmentName.text
                    self.assesment.moduleName = self.moduleName.text
                    self.assesment.dueDate = self.dueDate.date
                    self.assesment.notes = self.notes.text
                    if self.calendarSwitch.isOn == true
                    {
                        addToCalendar.callenderTitle(assesmentName: self.assesmentName.text!, dueDate: self.dueDate.date, notes: self.notes.text!, completion: { (success) -> Void in
                            //print("Second line of code executed")
                            if success != "notAdded" {
                                self.assesment!.eventID = success
                                DispatchQueue.main.async {
                                    (UIApplication.shared.delegate as! AppDelegate).saveContext()                                }
                                
                            } else {
                                self.assesment!.eventID = success
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()                                   }
                        })
                    }else if self.calendarSwitch.isOn == false{
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    }
                    
                }else if bool! == false{
                    let alert = UIAlertController(title: "Something went wrong", message: "Assesment value % and Acheived Marks must be an numerical value and Level must be between 3 and 7", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    return
                    
                }
                
            }
            
        }
    }
    
    
//    if moduleNameTextFields.text == "" || assesmentNameTextField.text == "" || valueOfAssesmentTextField.text == "" || acheivedMarkTextField.text == ""  || notesTextField.text == "" {
//            let alert = UIAlertController(title: "Something went wrong", message: "Module Name, Assesment Name, Value of Assesment or Acheived Marks must not be empty", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(action)
//            self.present(alert, animated: true, completion: nil)
//        }else{
//            let newAssesment = Assesment(context: self.context)
//
//            addAssesmentViewController.checkForCharacters (value: self.acheivedMarkTextField, marks: self.valueOfAssesmentTextField ,textFieldLevel: level) { bool in
//                print(bool!)
//                if bool! == false{
//                    let alert = UIAlertController(title: "Something went wrong", message: "Assesment value % and Acheived Marks must be an numerical value and Level must be between 3 and 7", preferredStyle: .alert)
//                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alert.addAction(action)
//                    self.present(alert, animated: true, completion: nil)
//                    return
//                }
//                else if bool! == true{
//                    //let newAssesment = Assesment(context: self.context)
//                    let marks = self.acheivedMarkTextField.text!
//                    newAssesment.markAwarded = Double(marks)!
//
//                    let value = self.valueOfAssesmentTextField.text!
//                    newAssesment.value = Double(value)!
//                    newAssesment.assesmentName = self.assesmentNameTextField.text
//                    newAssesment.moduleName = self.moduleNameTextFields.text
//                    newAssesment.dueDate = self.dueDatePicker.date
//                    newAssesment.notes = self.notesTextField.text
//                    //newAssesment.level = Int64(level.text)
//                    let date = Date()
//                    newAssesment.todayDate = date
//
//                    if self.callenderAdd.isOn == true
//                    {
//                        addToCalendar.callenderTitle(assesmentName: self.assesmentNameTextField.text!, dueDate: self.dueDatePicker.date, notes: self.notesTextField.text!, completion: { (success) -> Void in
//                            if success != "notAdded" {
//
//                                newAssesment.eventID = success
//                                DispatchQueue.main.async {
//                                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
//                                }
//                            } else if success == "error"{
//                                DispatchQueue.main.async {
//                                   let alert = UIAlertController(title: "Something went wrong", message: "The start date must be before the end date", preferredStyle: .alert)
//                                   let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//                                   alert.addAction(action)
//                                   self.present(alert, animated: true, completion: nil)
//                                }
//
//                            } else {
//                                newAssesment.eventID = success
//                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
//
//                            }
//                        })
//                    }else if self.callenderAdd.isOn == false
//                    {
//                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
//
//                    }
//                }
//                DispatchQueue.main.async {
//                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
//                }
//            }
//        }
//    }
}
