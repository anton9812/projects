//
//  DetailViewController.swift
//  CW2
//
//  Created by Anton Samuilov on 10/03/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate  {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var taskPercentComplete: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    // @IBOutlet weak var leftView: leftGraphView!
    var container = shared.SharedTasks.tasks
    
    var currentTask : Task?
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var total:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        calculate()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
        configureView()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
    }
    @objc func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }
    
    var assesment: Assesment? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = assesment {
            if let label = detailDescriptionLabel {
                label.text = detail.moduleName
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let identity = segue.identifier{
            switch identity {
            case "AssesmentDetailed" :
                let destinationVC = segue.destination as! topDetailViewController
                
                if let name = self.assesment?.assesmentName
                {
                    destinationVC.assesmentName = name
                    destinationVC.assesmet = self.assesment
                }
                
            default: break
                
            }
        }
        if segue.identifier == "addTask" {
            let obj = self.assesment
            //print(obj?.assesmentName)
            let destVC = segue.destination as! addTaskViewController
            destVC.taskAssesment = obj
        }
        if segue.identifier == "editTask" {
            let assesment = self.assesment
            let destVC = segue.destination as! editTaskViewController
            let obj = self.currentTask
            if obj == nil
            {
                let alert = UIAlertController(title: "Something went wrong", message: "Please select a Task to edit", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else if obj != nil
            {
                destVC.taskAssesmentEdit = obj
                destVC.assesesmet = assesment
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rows = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        
        return rows.numberOfObjects
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! taskCellTableViewCell
       // UIColor(red: 51/255, green: 153/255, blue: 255/255, alpha: 1)
        
        cell.LeftGraphView.backgroundColor = UIColor(red: 102/255, green: 178/255, blue: 255/255, alpha: 1)
        cell.rightGraphView.backgroundColor = UIColor(red: 102/255, green: 178/255, blue: 255/255, alpha: 1)
       

        

    }
    @objc func buttonAction(sender: UIButton){
        
        if let notes = self.fetchedResultsController.fetchedObjects?[sender.tag]{
                   //print(notes.taskName)
                   currentTask = notes
        }
        print(sender.tag)
        
        let initialIndexPath1 =  NSIndexPath(row: 0, section: 0)
                     self.performSegue(withIdentifier: "editTask", sender: initialIndexPath1)


        
    }
    func calculate(StartDate: Date, DueDate: Date, completion: @escaping  (Double, Int) -> ()){
        //let dateOfAdd = self.currentTask?.startDate!
        //guard let sub = self.currentTask?.taskDueDate! else {return}
        
       // print(sub,  dateOfAdd)
        
        let date = Date()
        //print(date)
        let totalDaysForAssesment = Calendar.current.dateComponents([.day], from: StartDate , to: DueDate).day!
        let daysFromToday = Calendar.current.dateComponents([.day], from: date , to: DueDate).day!
        
        let difference = totalDaysForAssesment - daysFromToday
        
        //totalDaysLeft.text = String(String(daysFromToday) + " Days Left")
        
        let Stroke = 1.0 / Double(totalDaysForAssesment)
       // print(Stroke)
//        if totalDaysForAssesment == daysFromToday
//        {
//            completion(0.0, daysFromToday )
//        }else if difference == 0
//        {
//            completion(1.0 , daysFromToday)
//
//        }else
//        {
            
            let days = Stroke * Double(difference)
            //print(days)
            completion(days , daysFromToday)
            
           // print(totalDaysForAssesment)
        //}
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! taskCellTableViewCell
        
        
        self.configureCell(cell, indexPath: indexPath)
        
        //cell.taskName.text = ""
        
      //  cell.backgroundColor = UIColor(red: 240/255, green: 235/255, blue: 229/255, alpha: 1)

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 102/255, green: 178/255, blue: 255/255, alpha: 1)
        cell.taskNumber.text = String("Task " + String((indexPath.item + 1) ))
        
        cell.editButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
               cell.editButton.tag = indexPath.row
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func configureCell(_ cell : taskCellTableViewCell, indexPath: IndexPath){
        
        
        cell.rightGraphView.r = 50
        cell.rightGraphView.amount = 71
        
        if  let a = fetchedResultsController.fetchedObjects?[indexPath.item].taskCompletion
        {
            // print(a!)
            //cell.LeftGraphView.amount = a
            //print(a)
            cell.LeftGraphView.r = 50
            cell.LeftGraphView.amount = CGFloat(Float(a))
        }
        if let start = fetchedResultsController.fetchedObjects?[indexPath.item].startDate , let due = fetchedResultsController.fetchedObjects?[indexPath.item].taskDueDate {
            self.calculate( StartDate: start, DueDate:due, completion: { (success, days) -> Void in
                
                cell.rightGraphView.amount = CGFloat(success)
                if days < 0
                {
                    cell.daysTocomplete.text = String("Overdue by: " + String(days) + " days" )
                }
                else
                {
                    cell.daysTocomplete.text = String(String(days) + " days left" )
                }
                
            })
            
        }
        
//         self.calculate( completion: { (success) -> Void in
//
//            cell.rightGraphView.amount = CGFloat(success)
//        })
        
        //cell.taskName.text = "none"
        
        if let notes = self.fetchedResultsController.fetchedObjects?[indexPath.item].notes
        {
            cell.taskNotes.text = notes
        }
        if let date = self.fetchedResultsController.fetchedObjects?[indexPath.item].taskDueDate
        {
            cell.taskDueDate.text = String("Due Date: " + DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none))
        }
        if let  d = self.fetchedResultsController.fetchedObjects?[indexPath.item].taskName
            
        {
            cell.taskName.text = d
        }
        if let  taskCompletion = self.fetchedResultsController.fetchedObjects?[indexPath.item].taskCompletion
            
        {
            cell.taskPercentCompleteLabel.text = String(String(taskCompletion) + " % complete")
        }
        
        
    }
    
    
    
    // MARK: - Fetched results controller
    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    var fetchedResultsController: NSFetchedResultsController<Task> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let currentAssesment = self.assesment 
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        
        let sort = NSSortDescriptor(key: "taskName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        // Edit the sort key as appropriate.
        //let sortDescriptor = NSSortDescriptor(key: "assesmentName", ascending: false)
        
        fetchRequest.sortDescriptors = [sort]
        
        if (self.assesment != nil){
            
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
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.reloadData()

            calculate()
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            calculate()
            tableView.deleteRows(at: [indexPath!], with: .fade)
            self.tableView.reloadData()
        case .update:
            calculate()
            // self.tableView.reloadData()
            self.configureCell(tableView.cellForRow(at: indexPath!) as! taskCellTableViewCell,indexPath: newIndexPath!)
        case .move:
            calculate()
            self.configureCell(tableView.cellForRow(at: indexPath!) as! taskCellTableViewCell,indexPath: newIndexPath!)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            return
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    func calculate(){
        var allPercent: Int = 0
        
        let count = self.fetchedResultsController.fetchedObjects?.count
        if count == 0 {
            return
        }else{
            for i in 0..<count! {
                
                
                let percent = self.fetchedResultsController.fetchedObjects?[i].taskCompletion
                allPercent = allPercent + Int(Int64(percent!))
                
                
                
                
                
            }
        }
        total = allPercent / count!
        shared.SharedTasks.total = CGFloat(total)
        
        //print(total)
        
        //vc.stroke = CGFloat(total)
    }
}





