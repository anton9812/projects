//
//  addTaskViewController.swift
//  CW2
//
//  Created by Anton Samuilov on 17/05/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit
import CoreData

class addTaskViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var completion: UILabel!
    @IBOutlet weak var dueDateView: UIView!
    @IBOutlet weak var startDateVIew: UIView!
    @IBOutlet weak var taskDueDate: UIDatePicker!
    @IBOutlet weak var tasStartDate: UIDatePicker!
    @IBOutlet weak var taskNotesField: UITextField!
    @IBOutlet weak var taskNameField: UITextField!
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var saveTask: UIButton!
    
    var taskAssesment :Assesment?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        setDateValidation()
        
        
        // Do any additional setup after loading the view.
        viewBorder(view: dueDateView)
        viewBorder(view: startDateVIew)
        
    }
    func viewBorder(view: UIView){
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.blue.cgColor
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        // Verify all the conditions
//        if let sdcTextField = textField as? SDCTextField {
//            return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
//        }
//    }
    
    @IBAction func percentageChanged(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        // print("Slider changing to \(currentValue) ?")
        
        completion.text = "\(currentValue) %"
        
        
        
    }
    func setDateValidation() {
        let calendar = Calendar.current
        let dateToday = calendar.dateComponents([.day,.month,.year], from: (taskAssesment?.todayDate!)!)
        
        var minDateComponent = calendar.dateComponents([.hour,.day,.month,.year], from: Date())
        minDateComponent.day = dateToday.day
        minDateComponent.month = dateToday.month
        minDateComponent.year = dateToday.year
        
        let minDate = calendar.date(from: minDateComponent)
        print(" min date : \(String(describing: minDate))")
        
        let dateDue = calendar.dateComponents([.day,.month,.year], from: (taskAssesment?.dueDate)!)
        
        var maxDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
        maxDateComponent.day = dateDue.day
        maxDateComponent.month = dateDue.month
        maxDateComponent.year = dateDue.year
        
        let maxDate = calendar.date(from: maxDateComponent)
        print("max date : \(String(describing: maxDate))")
        
        tasStartDate.minimumDate = minDate! as Date
        tasStartDate.maximumDate =  maxDate! as Date
        taskDueDate.minimumDate = minDate! as Date
        taskDueDate.maximumDate =  maxDate! as Date
        
    }
    
    @IBAction func saveTaskPressed(_ sender: Any) {
        //print(taskAssesment?.assesmentName!)
        
        
        
        if taskNotesField.text == "" || taskNameField.text == ""{
            let alert = UIAlertController(title: "Something went wrong", message: "Task Name and Task notes must not be empty", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else{
            let task = Task(context: context)
            
            task.assesment = taskAssesment?.assesmentName
            
            task.taskCompletion = Int64(Int(slider.value))
            task.notes = taskNotesField.text
            
            
            
            let calendar = Calendar.current
                       
            
            
            
             //let calendar = Calendar.current
            let originalDate = taskDueDate.date
            let minDateComponent = calendar.date(bySettingHour: 13, minute: 00, second: 00, of: originalDate)
            var dateToday = calendar.dateComponents([.day,.month,.year], from: Date())
            dateToday.hour = 0
            dateToday.minute = 00
            
//            minDateComponent.hour = dateToday.hour
//            minDateComponent.minute = dateToday.minute
           // let minDate = calendar.date(from: minDateComponent)
             print(" min date : \(String(describing: minDateComponent))")
           
            
            
            
            task.taskDueDate = minDateComponent
            task.startDate = tasStartDate.date
            task.taskName = taskNameField.text
            //task.lengthInDays = Int64(estTimeToComplete.text!)!
            
            
            if self.reminderSwitch.isOn == true
            {
                addToCalendar.callenderTitle(assesmentName: self.taskNameField.text!, dueDate: self.taskDueDate.date, notes: self.taskNotesField.text!, completion: { (success) -> Void in
                    //print("Second line of code executed")
                    if success == "notAdded" {
                        task.eventID = success
                        self.taskAssesment?.addToAssesmentTask(task)
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
                        
                    }else{
                        task.eventID = success
                        self.taskAssesment?.addToAssesmentTask(task)
                        DispatchQueue.main.async {
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            
                        }
                        
                    }
                })
            }
            else if self.reminderSwitch.isOn == false
            {
                task.eventID = "notAdded"
                taskAssesment?.addToAssesmentTask(task)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
            }
            
            
            
            
        }
        
    }
    
}
