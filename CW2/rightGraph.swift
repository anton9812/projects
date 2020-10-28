//
//  rightGraph.swift
//  CW2
//
//  Created by Anton Samuilov on 20/05/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import Foundation
import UIKit

class rightGraph: UIView {
    
    
    var circleDays: Graph!
    var amount: CGFloat!
    var right: CGFloat!
    var r : CGFloat!
    var days: Double!
    
    override func draw(_ rect: CGRect) {
        circleDays = Graph(frame: CGRect(x: -10, y: -50, width: 100 ,height:100))
        circleDays.progressColor = UIColor(red: 255.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        if amount != nil{
            
            circleDays.stroke = amount! / 100
            if amount > 0 && amount <= 0.3
                
            {
                 circleDays.progressColor =  UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0)
                
            }else if amount > 0.3 && amount <  0.7
            {
                circleDays.progressColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
            }
            else if amount >= 0.7
            {
                circleDays.progressColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            }
        }
        
        
        
        circleDays.tag = 104
        circleDays.r = r
        //cp.radious = 50
        
        //cp.center = self.center
        self.addSubview(circleDays)
        
        
        self.perform(#selector(animateProgress), with: nil,  afterDelay: 0.0)
    }
    
    @objc func animateProgress() {
        let circleUpdage = self.viewWithTag(104 ) as! Graph
        print(amount!)
         circleUpdage.setProgressWithAnimation( duration: 0.0, value: amount! , value2: 1.0)
        
        
        
    }
}
