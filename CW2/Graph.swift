//
//  leftTopGraph.swift
//  CW2
//
//  Created by Anton Samuilov on 18/05/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class Graph: UIView {
    
    //reference
    //Swift Tutorial :- Create circularProgressView / circular progress bar iOS swift. (2018). YouTube. Available at: https://www.youtube.com/watch?v=Qh1Sxict3io&t=991s [Accessed 1 Jun. 2020].
    
    
    
    

    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    var r: CGFloat = 90 {
        didSet{
            createCircularPath(r: r)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //createCircularPath(r: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //createCircularPath()
        //progressLayer.needsDisplayOnBoundsChange = true
        //self.progressLayer.didChangeValue(forKey: "progress")
    }
    
    var progressColor = UIColor.white {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    var stroke = CGFloat(0.0) {
        didSet {
            progressLayer.strokeEnd = stroke
        }
    }
    
    
    
    
    func stroke(value: CGFloat){
        progressLayer.strokeEnd = value
        
    }
    
    func createCircularPath(r: CGFloat) {
        
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width , y: frame.size.height ), radius: r, startAngle: CGFloat(-0.5 * .pi), endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor(red: 211/255, green: 211/255, blue: 230/255, alpha: 1).cgColor
        trackLayer.lineWidth = 10.0
        trackLayer.strokeEnd = 0.0
        trackLayer.lineCap = .round
        
        layer.addSublayer(trackLayer)
       
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 10.0
        progressLayer.lineCap = .round
        progressLayer.name = "progress"
        
        
        progressLayer.strokeEnd = 0.0
        
        
        
        layer.addSublayer(progressLayer)
    }
    func setProgressWithAnimation(duration: TimeInterval, value: CGFloat,value2: CGFloat) {
    //   print( value)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fromValue = 0
        animation.toValue = Float(value)
        //animation.fillMode = 
       // animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = value
        trackLayer.strokeEnd = CGFloat(value2)
        //trackLayer.strokeEnd = CGFloat(value)

        //trackLayer.add(animation, forKey: "animateprogress")
        progressLayer.add(animation, forKey: "animateprogress")
    }
    
    
}
