//
//  Callenderr.swift
//  CW2
//
//  Created by Anton Samuilov on 27/05/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class addToCalendar {
    
   static var id: String!
   
    static func callenderTitle( assesmentName: String, dueDate: Date, notes: String, completion: @escaping  (String) -> ()){
        let eventStore : EKEventStore = EKEventStore()
        
        
        eventStore.requestAccess(to: EKEntityType.reminder, completion:
            {(granted, error) in
                if !granted {
                    print("Access to store not granted")
                }
        })
        eventStore.requestAccess(to: .event) {  (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                //  print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title =  assesmentName
                event.startDate = dueDate
                event.endDate = dueDate
                event.notes = notes
                //create an alarm (alert on the calendar event)
                let alarm:EKAlarm = EKAlarm()
                alarm.relativeOffset = 60 * -60 //1 hour before in seconds
                //add the alarm
                event.addAlarm(alarm)
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                     id = event.eventIdentifier ?? "notAdded"
                    if id == "notAdded"{
                        completion("error")
                    }else{
                        completion(id)
                    }
                   
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                    //id = "error"
                    completion("error")
                    
                }
                print("Saved Event")
                
            }
            else{
                
                print("failed to save event with error : \(String(describing: error)) or access not granted")
                 completion("error")
            }
        }
    }
    static func deleteEvent(_ storedEventID: String)
    {    let eventStore : EKEventStore = EKEventStore()

        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil)
            {

                if let calendarEvent_toDelete = eventStore.event(withIdentifier: storedEventID){

                    //recurring event
                    if calendarEvent_toDelete.recurrenceRules?.isEmpty == false
                    {
                        let alert = UIAlertController(title: "Repeating Event", message:
                            "This is a repeating event.", preferredStyle: UIAlertController.Style.alert)

                        //delete this event only
                        let thisEvent_Action = UIAlertAction(title: "Delete this event", style: UIAlertAction.Style.default)
                        {
                            (result : UIAlertAction) -> Void in

                            //sometimes doesn't delete anything, sometimes deletes all reccurent events, not just current!!!
                            do{
                                try eventStore.remove(calendarEvent_toDelete, span: .thisEvent)
                            } catch _ as NSError{return}

                        }


                        alert.addAction(thisEvent_Action)

                    }
                        //not recurring event
                    else{
                        //works fine
                        do{
                            try eventStore.remove(calendarEvent_toDelete, span: EKSpan.thisEvent)
                        } catch _ as NSError{
                            return
                        }
                    }
                }

            }
        })
    }
}
