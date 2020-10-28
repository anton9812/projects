//
//  taskCellTableViewCell.swift
//  CW2
//
//  Created by Anton Samuilov on 16/05/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class taskCellTableViewCell: UITableViewCell {

//    var cp: Graph!
//    var amount: Float!
//    var r : CGFloat!
    @IBOutlet weak var taskNumber: UILabel!
    @IBOutlet weak var rightGraphView: rightGraph!
    @IBOutlet weak var LeftGraphView: leftGraphView!
    @IBOutlet weak var taskDueDate: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskPercentCompleteLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var daysTocomplete: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var taskNotes: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

   
    }
}


        
        
        
        
    


