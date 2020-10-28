//
//  leftGraphViewController.swift
//  CW2
//
//  Created by Anton Samuilov on 18/05/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class leftGraphView: UIView {
    
    
    var circlePercentTask: Graph!
    var amount: CGFloat!
    var r : CGFloat!

    override func draw(_ rect: CGRect) {
        circlePercentTask = Graph(frame: CGRect(x: -60, y: -50, width: 100 ,height:100))
        
        if amount > 0 && amount <= 30
        
        {
             circlePercentTask.progressColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        }else if amount > 30 && amount <  70
        {
            circlePercentTask.progressColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
        }
        else if amount >= 70
        {
            circlePercentTask.progressColor =  UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0)
        }
        //cp.progressColor = UIColor(red: 255.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        //print(amount)
        //print(r)
        if amount == nil{
            
        }else{
            print()
            circlePercentTask.stroke = amount! / 100
        }
        
        circlePercentTask.tag = 103
        circlePercentTask.r = r
        //cp.radious = 50
        
        //cp.center = self.center
        self.addSubview(circlePercentTask)
        
        
        self.perform(#selector(animateProgress), with: nil,  afterDelay: 0.0)
    }
   
    @objc func animateProgress() {
        let cP = self.viewWithTag(103 ) as! Graph
       
        cP.setProgressWithAnimation( duration: 0.0, value: amount! / 100, value2: 1.0)
       
        
        
    }
}
