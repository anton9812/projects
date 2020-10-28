//
//  FinCalculator.swift
//  CW1
//
//  Created by Anton Samuilov on 02/03/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import Foundation
import UIKit




class FinCalculator {
    
    var NumberofPayments: Double = 12.0
    var imageD: UIImageView!
    
    func PresentValue (futureValue: Double, interest: Double, Years: Double) -> Double {
        
        let B = 1 + (interest / 100) / NumberofPayments
        let multiplier = pow(B, NumberofPayments * Years)
        let answer = futureValue / multiplier
        
        return answer
    }
    func FutureValue(presentValue: Double, interest: Double, Years: Double) -> Double {
        
        let A = (1 + (interest / 100) / NumberofPayments)
        let multiplier = pow(A, NumberofPayments * Years)
        
        return multiplier * presentValue
    }
    func interestValue(futureValue: Double, presentValue: Double, Years: Double) -> Double{
        
        let a = futureValue / presentValue
        let b = 1 / (NumberofPayments * Years)
        let brackets = pow(a, b) - 1
        let answer = NumberofPayments * brackets
        
        
        return answer * 100
    }
    func compoundsPerYear(futureValue: Double, presentValue: Double, interest: Double) -> Double{
        
        let top = log(futureValue / presentValue)
        let bottom1 = 1 + ((interest / 100) / NumberofPayments)
        let bottom2 = NumberofPayments * (log(bottom1))
        let answer = top / bottom2
        return answer
        
    }
    func futureValueWithPMT(PMT: Double,interest: Double, Years: Double,principelAmount: Double) -> Double {
        
        
        let a = ((interest / 100) / NumberofPayments) + 1
        let b = (NumberofPayments * Years)
        let brackets = pow(a, b)
        
        let f1 =  FutureValue(presentValue: principelAmount, interest: interest, Years: Years)
        let bracket1 = brackets - 1
        let bottom = (interest / 100) / NumberofPayments
        let sum1 = bracket1 / bottom
        let answer = PMT * sum1
        
        return answer + f1
        
        
    }
    func paymentSavings(futureValue: Double,interest: Double, Years: Double,principelAmount: Double) -> Double{
        let f1 =  FutureValue(presentValue: principelAmount, interest: interest, Years: Years)
        
        let a = ((interest / 100) / NumberofPayments) + 1
        let b = (NumberofPayments * Years)
        let brackets = pow(a, b)
        let bracket1 = brackets - 1
        
        let bottom = (interest / 100) / NumberofPayments
        let sum1 = bracket1 / bottom
        let answer = (futureValue - f1) / sum1
        
        return answer
    }
    func yearsSavingsWithPayment(interest: Double, payment: Double, futureValue: Double, principelAmount : Double) -> Double{
        
        let top = (interest / 100) * futureValue + (payment * NumberofPayments)
        let bottom = (interest / 100) * principelAmount +  (payment * NumberofPayments)
        let toLog = top / bottom
        let TOP  = log(toLog)
        
        let bottom2 = 1 + ((interest / 100) / NumberofPayments)
        let log1 = log(bottom2)
        let BOTTOM = NumberofPayments * log1
        let answer = TOP / BOTTOM
        
        
        return answer
        
    }
    
    
    
    func paymentMortgage(presentValue: Double, interest: Double, numberOfYears: Double) -> Double{
        
        let top = presentValue * ((interest/100) / 12)
        let topBrackets = 1 + ((interest/100) / 12)
        let topAll = pow( topBrackets, (12 * numberOfYears))
        let topAll1 = top * topAll
        
        let bottom = (1 + ((interest/100) / 12))
        let bottom1 = pow(bottom, (12 * numberOfYears))
        let bottomAll = bottom1 - 1
        let answer = topAll1 / bottomAll
        
        return answer
    }
    func yearsMortgage(presentValue: Double, interest: Double, payment: Double) -> Double{
        
        /*let topBrackets = (((interest / 100) * presentValue) / payment) - 1
        let bottom = log(1 + interest / 100) * 12
        let all = topBrackets / bottom
        let answer = log(all)
        */
        
        
        
        let top = -12 * payment
        
        let bottom = (presentValue * (interest / 100)) - (12 * payment)
        let topLog = log(top/bottom)
        let bottomBottom = ((interest / 100) + 12) / 12
        let bottomBottom1 = 12 * log(bottomBottom)
        let answer = topLog / bottomBottom1
        
        
        return answer
       
        
        
    }
    func paymentLoan(loanAmount: Double, interest: Double, numberOfYears: Double) -> Double{
        
        
        let top = loanAmount * ((interest/100) / 12)
        let topBrackets = 1 + ((interest/100) / 12)
        let topAll = pow( topBrackets, (12 * numberOfYears))
        let topAll1 = top * topAll
        
        let bottom = (1 + ((interest/100) / 12))
        let bottom1 = pow(bottom, (12 * numberOfYears))
        let bottomAll = bottom1 - 1
        let answer = topAll1 / bottomAll
        
        return answer
    }
    func yearsLoan(loanAmount: Double, interest: Double, payment: Double) -> Double{
        
        
        let top = -12 * payment
        
        let bottom = (loanAmount * (interest / 100)) - (12 * payment)
        let topLog = log(top/bottom)
        let bottomBottom = ((interest / 100) + 12) / 12
        let bottomBottom1 = 12 * log(bottomBottom)
        let answer = topLog / bottomBottom1
        
        
        return answer * 12
        
    }
    
    
    func popUpView(myView : UIView, MyLable: UILabel, myButton : UIButton) -> UIView{ // using the instances of view, button, lable insiide the controller its called.
        
        imageD = UIImageView() // creating an instance of UIImageView
        myButton.setTitle("Dismiss",for: .normal) //setting he title for the button
        myButton.layer.backgroundColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor
        MyLable.text = "Fill in the fields and leave empty the fields you want to be calculated.  \n\nNote: Highlight the field you want to be calculated and press the Calculate button."
        MyLable.numberOfLines = 0
        
       
        myView.frame = CGRect(x:  45, y: 150, width: 280, height: 400) // setting the dimentions of the view
        MyLable.frame = CGRect(x:  15, y: -120, width: myView.frame.width - 15, height: myView.frame.height)// setting the dimentions and position of the lable
        imageD.image = UIImage(named: "Display.png") //screenshot of how the highlited field looks like
        imageD.frame = CGRect(x:  15, y: 155, width: myView.frame.width - 40, height: myView.frame.height - 230) // setting the dimentions and position of the image
        myButton.frame = CGRect(x: 90, y: 330, width: 100, height: 50) // setting the dimentions and position of the button
        myButton.layer.cornerRadius = 15
        myView.layer.cornerRadius = 10
        myView.backgroundColor = UIColor.white
        myView.isHidden = false
        
        myView.addSubview(imageD) // adding the elements to the custom view
        myView.addSubview(MyLable)
        myView.addSubview(myButton)
        
        return myView //return the view
        
        
    }
}

