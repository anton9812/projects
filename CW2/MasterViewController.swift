//
//  MasterViewController.swift
//  CW2
//
//  Created by Anton Samuilov on 10/03/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate,UISplitViewControllerDelegate {
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    @IBOutlet weak var marksAcheivedLabel: UILabel!
    var currentAssesment: Assesment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitViewController?.delegate = self
        
        // Do any additional setup after loading the view.
        //navigationItem.leftBarButtonItem = editButtonItem
        
        self.performSegue(withIdentifier: "showDetail", sender: self)
        
        
        //self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        if let detailViewController = secondaryViewController as? DetailViewController, let primaryNV = primaryViewController as? UINavigationController  {
            primaryNV.pushViewController(detailViewController, animated: false)
            
            return true
        }
        return false // let the iOS handles it.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        if fetchedResultsController.fetchedObjects?.count != 0{
            let initialIndexPath = NSIndexPath(row: 0, section: 0)
            
            tableView.selectRow(at: initialIndexPath as IndexPath, animated: false, scrollPosition: .none)
            
            
            let initialIndexPath1 =  NSIndexPath(row: 0, section: 0)
            self.performSegue(withIdentifier: "showDetail", sender: initialIndexPath1)
        }
       
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        let context = self.fetchedResultsController.managedObjectContext
        // let newEvent =  Event(context: context)
        //let event = Assesment(context: context)
        //event.assesmentName = "FYP"
        
        
        
        // If appropriate, configure the new managed object.
        //newEvent.timestamp = Date()
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "showDetail" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                self.currentAssesment = object
                //print(currentAssesment?.assesmentName!)
                controller.assesment = object
                
                
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
                
            }
        }
        
        
        if segue.identifier == "editAssesment"{
            
            let destination =  segue.destination as! editAssesmentViewController
            if currentAssesment == nil
            {
                let alert = UIAlertController(title: "Something went wrong", message: "Please select an Assesment to edit", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                destination.assesment = self.currentAssesment
                
            }
        }
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MasterTableViewCell
        cell.backgroundColor = UIColor(red: 102/255, green: 178/255, blue: 255/255, alpha: 1)
        
    }
   
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //print(fetchedResultsController.sections?.count)
        return fetchedResultsController.sections?.count ?? 0
    }
     func btnDelAll_touchupinside() {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext

        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Assesment")
        let req = NSBatchDeleteRequest(fetchRequest: fetchReq)

        do {
            try managedObjectContext.execute(req)

        } catch {
            // Error Handling
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        print(sectionInfo.numberOfObjects)
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MasterTableViewCell
        // print(fetchedResultsController.fetchedObjects?.count)
        // print(indexPath.item)
        //cell.backgroundColor = UIColor(red: 102/255, green: 178/255, blue: 255/255, alpha: 1)
        let assesment = fetchedResultsController.object(at: indexPath)
        cell.moduleName.font = UIFont.boldSystemFont(ofSize: 25.0)
        cell.assesmentName.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.assesmentName.text = assesment.assesmentName
        cell.moduleName.text = assesment.moduleName
        cell.marksAcheived.text =  String("Marks: " + String(assesment.markAwarded))
        cell.valueOfModule.text = String("Value: " + String(assesment.value))
        configureCell(cell, withAssesment: assesment)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    func configureCell(_ cell: UITableViewCell, withAssesment assesment: Assesment) {
        //cell.textLabel!.text = assesment.assesmentName
        
        
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Assesment> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Assesment> = Assesment.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "assesmentName", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
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
        
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<Assesment>? = nil
    
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
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
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            if let id = fetchedResultsController.fetchedObjects?[indexPath!.item].eventID {
                addToCalendar.deleteEvent(id)
            }
            
            
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, withAssesment: anObject as! Assesment)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, withAssesment: anObject as! Assesment)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //self.tableView.reloadData()
        tableView.endUpdates()
    }
    
   
}

