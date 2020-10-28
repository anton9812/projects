//
//  assesmentViewController.swift
//  CW2
//
//  Created by Anton Samuilov on 16/05/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit
import CoreData

class topDetailViewController: UIViewController, NSFetchedResultsControllerDelegate {
    var total:Double! = 1.0
    
    var mainCircles: Graph!
    var days: Double!
    @IBOutlet weak var dayLeftToCOmplete: UIView!
    @IBOutlet weak var AssesmentSummary: UILabel!
    @IBOutlet weak var completionPercentLable: UILabel!
    var assesmet: Assesment?
    var stroke : CGFloat? {
        didSet{
            //self.view.layoutIfNeeded()
        }
    }
    var globalTotal = shared.SharedTasks.total
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var totalDaysLeft: UILabel!
    @IBOutlet weak var assesmentNotes: UILabel!
    @IBOutlet weak var dayLeftView: UIView!
    @IBOutlet weak var percentageComplete: Graph!
    @IBOutlet weak var assesmentNameLable: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    var assesmentName = "Assesment Name"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        if assesmet?.assesmentName == nil
        {
            self.AssesmentSummary.text = "Choose an assesment"
        } else if assesmet?.assesmentName != nil{
            self.assesmentNameLable.text = assesmet?.assesmentName ?? assesmentName
            self.assesmentNotes.text = assesmet?.notes ?? "none"
            self.dueDateLabel.text = String("Due Date: " + DateFormatter.localizedString(from: (assesmet?.dueDate)!, dateStyle: .long, timeStyle: .none))
        }
        self.view.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1).cgColor
        self.view.layer.borderWidth = 0.2
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        percentageCompleteCalculation()
        daysToComplete()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    
    func percentageCompleteCalculation(){
        //myView.layer.sublayers?.removeAll()
        var allPercent: Int = 0
        
        let count = self.fetchedResultsController.fetchedObjects?.count
        if count == 0 {
            total = 0.0
            completionPercentLable.text = (String(Int(0 ) ) + " % complete")
        }else{
            for i in 0..<count! {
                
                
                let percent = self.fetchedResultsController.fetchedObjects?[i].taskCompletion
                allPercent = allPercent + Int(Int64(percent!))
            }
            let value = Double(Int(allPercent / count!))
            total = value / 100
            
            completionPercentLable.text = (String(Int(value ) ) + " % complete")
            
        }
        //print(total)
        
        
        
        graphPercentageCOmplete()
    }
    
    
    func daysToComplete(){
        
        mainCircles = Graph(frame: CGRect(x: -230, y: -80, width: view.bounds.width / 2 ,height: view.bounds.height / 2))
        
        mainCircles.progressColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 255.0/255.0, alpha: 1.0)
        //cp.radious = 80
        
        
        
        mainCircles.r = 80
        mainCircles.tag = 102
        
        self.dayLeftView.addSubview(mainCircles)
        
        
        self.perform(#selector(animateProgress), with: nil,  afterDelay: 0.0)
        
        //percentageComplete.trackColor = UIColor.white
        //percentageComplete.progressColor = UIColor.purple
        
        
    }
    func graphPercentageCOmplete( ){
        mainCircles = Graph(frame: CGRect(x: -270, y: -80, width: view.bounds.width / 2 ,height: view.bounds.height / 2))
        
        mainCircles.progressColor = UIColor(red: 00/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
        
        
        if total*100 > 0 && total*100 <= 30
            
        {
            mainCircles.progressColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        }else if total*100 > 30 && total*100 <  70
        {
            mainCircles.progressColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
        }
        else if total*100 >= 70
        {
            mainCircles.progressColor =  UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0)
        }
        
        
        mainCircles.tag = 101
        mainCircles.r = 80
        // cp.radious = 80
        self.percentageComplete.addSubview(mainCircles)
        
        
        self.perform(#selector(animateProgress), with: nil,  afterDelay: 0.0)
        
        //percentageComplete.trackColor = UIColor.white
        // percentageComplete.progressColor = UIColor.purple
        
    }
    
    
    
    
    
    @objc func animateProgress() {
        let circlePercent = self.view.viewWithTag(101) as! Graph
        let circleDays = self.view.viewWithTag(102) as! Graph
        
        
        guard  let dateOfAdd = self.assesmet?.todayDate else {return}
        guard let sub = self.assesmet?.dueDate else {return}
        
        // print(sub,  dateOfAdd)
        
        let date = Date()
        //print(date)
        let totalDaysForAssesment = Calendar.current.dateComponents([.day], from: dateOfAdd , to: sub).day!
        let daysFromToday = Calendar.current.dateComponents([.day], from: date , to: sub).day!
        
        let difference = totalDaysForAssesment - daysFromToday
        
        totalDaysLeft.text =  String(String(daysFromToday) + " days left" )
        
        
        let Stroke = 1.0 / Double(totalDaysForAssesment)
        //print(Stroke)
        if totalDaysForAssesment == daysFromToday
        {
            days = 0.0
        }else if difference == 0
        {
            days = 1.0
            
        }else
        {
            
            days = Stroke * Double(difference)
            //print(days)
            
            //  print(totalDaysForAssesment)
        }
        //        if days > 0 && days <= 0.3
        //
        //        {
        //            mainCircles.progressColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        //        }else if days > 0.3 && days <  0.7
        //        {
        //            mainCircles.progressColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
        //        }
        //        else if days >= 0.7
        //        {
        //            mainCircles.progressColor =  UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0)
        //        }
        
        
        
        
        
        circlePercent.setProgressWithAnimation( duration: 0.0, value: CGFloat(Float(total!)), value2: 1.0)
        //print(days)
        circleDays.setProgressWithAnimation(duration: 0.0, value: CGFloat(days), value2: 1.0)
        
        
        
        
        
    }
    
    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    var fetchedResultsController: NSFetchedResultsController<Task> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let currentAssesment = self.assesmet
        //print(currentAssesment?.assesmentName!)
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        
        let sort = NSSortDescriptor(key: "taskName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        // Edit the sort key as appropriate.
        //let sortDescriptor = NSSortDescriptor(key: "assesmentName", ascending: false)
        
        fetchRequest.sortDescriptors = [sort]
        
        if (self.assesmet != nil){
            
            let pret = NSPredicate(format: "assesmentTask = %@", currentAssesment!)
            fetchRequest.predicate = pret
            
        }else{
            
        }
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController<Task>(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: #keyPath(Task.assesment), cacheName: nil)
        
        aFetchedResultsController.delegate = self
        
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        // container.append(_fetchedResultsController!)
        return _fetchedResultsController!
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            percentageCompleteCalculation()
            
            self.loadViewIfNeeded()
            
        case .delete:
            percentageCompleteCalculation()
            
            self.loadViewIfNeeded()
        case .update:
            percentageCompleteCalculation()
            
            
        default:
            return
        }
    }
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    //        switch type {
    //        case .insert:
    //          //  loadProgress()
    //            //self.viewDidLoad()
    //            self.view.layoutIfNeeded()
    //        case .delete:
    //
    //            self.view.layoutIfNeeded()
    //        default:
    //            return
    //        }
    //
    //    }
    
    
    
    
    
}
