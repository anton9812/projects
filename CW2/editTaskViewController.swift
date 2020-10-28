//
//  editTaskViewController.swift
//  CW2
//
//  Created by Anton Samuilov on 20/05/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class editTaskViewController: UIViewController {
    
    @IBOutlet weak var taskname: UITextField!
    @IBOutlet weak var taskNotes: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var updateTaskButton: UIButton!
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var percentCompleteLabel: UILabel!
    @IBOutlet weak var percentComplete: UISlider!
    @IBOutlet weak var startDate: UIDatePicker!
    
    @IBOutlet weak var remoderSwitch: UISwitch!
    var taskAssesmentEdit :Task?
    var assesesmet : Assesment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set18YearValidation()
        // print(taskAssesmentEdit?.taskName)
        // print(taskAssesmentEdit?.notes!)
        
        taskname.text = taskAssesmentEdit?.taskName
        taskNotes.text  = taskAssesmentEdit?.notes
        dueDate.setDate((taskAssesmentEdit?.taskDueDate)!, animated: true)
        startDate.setDate((taskAssesmentEdit?.startDate)!, animated: true)
        percentComplete.setValue(Float(taskAssesmentEdit!.taskCompletion), animated: true)
        //let complete = Int(\(taskAssesmentEdit?.taskCompletion)"
        percentCompleteLabel.text = "\(taskAssesmentEdit?.taskCompletion ?? 22 ) % "
        let eventID  = taskAssesmentEdit?.eventID
        if eventID == "notAdded"{
            
        }else{
            addToCalendar.deleteEvent(eventID!)
            
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func sliderValue(_  sender: UISlider) {
        let currentValue = Int(sender.value)
        // print("Slider changing to \(currentValue) ?")
        
        percentCompleteLabel.text = "\(currentValue) %"
        
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        
        
        
        if taskname.text == "" || taskNotes.text == ""{
            
            let alert = UIAlertController(title: "Something went wrong", message: "Task Name and Task Notes are mandatory fields", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else{
            
            
            taskAssesmentEdit?.taskName = taskname.text
            taskAssesmentEdit?.notes = taskNotes.text
            taskAssesmentEdit?.taskDueDate = dueDate.date
            taskAssesmentEdit?.startDate = startDate.date
            taskAssesmentEdit?.taskCompletion =  Int64(Int(percentComplete.value))
            //(UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            if self.reminderSwitch.isOn == true
            {
                addToCalendar.callenderTitle(assesmentName: self.taskname.text!, dueDate: self.dueDate.date, notes: taskNotes.text!, completion: { (success) -> Void in
                    //print("Second line of code executed")
                    if success != "notAdded" {
                        self.taskAssesmentEdit!.eventID = success
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
                        self.taskAssesmentEdit!.eventID = success
                        DispatchQueue.main.async {
                             (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        }
                                                          }
                })
            }else if self.reminderSwitch.isOn == false
            {
                 self.taskAssesmentEdit!.eventID = "notAdded"
                DispatchQueue.main.async {
                     (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
                
            }
        }
    }
    func set18YearValidation() {
        let calendar = Calendar.current
        let dateToday = calendar.dateComponents([.day,.month,.year], from: Date())
        
        guard let dateOfStart = assesesmet?.todayDate else {return}
        var minDateComponent = calendar.dateComponents([.hour,.day,.month,.year], from: (dateOfStart))
        minDateComponent.day = dateToday.day
        minDateComponent.month = dateToday.month
        minDateComponent.year = dateToday.year
        
        let minDate = calendar.date(from: minDateComponent)
        print(" min date : \(String(describing: minDate))")
        
        let dateDue = calendar.dateComponents([.day,.month,.year], from: (assesesmet?.dueDate)!)
        
        var maxDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
        maxDateComponent.day = dateDue.day
        maxDateComponent.month = dateDue.month
        maxDateComponent.year = dateDue.year
        
        let maxDate = calendar.date(from: maxDateComponent)
        print("max date : \(String(describing: maxDate))")
        
        startDate.minimumDate = minDate! as Date
        startDate.maximumDate =  maxDate! as Date
        dueDate.minimumDate = minDate! as Date
        dueDate.maximumDate =  maxDate! as Date
        
    }
    
    
}
