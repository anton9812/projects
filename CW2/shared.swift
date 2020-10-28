//
//  shared.swift
//  CW2
//
//  Created by Anton Samuilov on 18/05/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class shared {
    
    
    static let SharedTasks = shared()
    var tasks = [NSFetchedResultsController<Task>?]()
    var total : CGFloat?
    
    static func calculate(){
        
    }
}

