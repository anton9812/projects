//
//  MortgageViewController.swift
//  CW1
//
//  Created by Anton Samuilov on 05/03/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class MortgageViewController: UIViewController, UITextFieldDelegate {
    let defaultData = UserDefaults.standard
    var popUp: UIView!
    var popLable : UILabel!
    var dismissB : UIButton!
    var validateResponder: Bool = false
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var numberOfYears: UITextField!
    @IBOutlet weak var payment: UITextField!
    @IBOutlet weak var interest: UITextField!
    @IBOutlet weak var futureValue: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.payment.delegate = self; // setting the delegate of the textfields to itself
        self.numberOfYears.delegate = self;
        self.interest.delegate = self;
        self.futureValue.delegate = self;
        
        payment.layer.cornerRadius = 10.0 //set the radious of the textfields
        numberOfYears.layer.cornerRadius = 10.0
        interest.layer.cornerRadius = 10.0
        futureValue.layer.cornerRadius = 10.0
        
        payment.setLeftPaddingPoints(10) //adding paddign to the left side of the textfield
        numberOfYears.setLeftPaddingPoints(10)
        interest.setLeftPaddingPoints(10)
        futureValue.setLeftPaddingPoints(10)
        
        
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap) // adding tapping recognision to the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        let selector1 = #selector(self.saveDataM) // adding an observer 
        let notificationCentre = NotificationCenter.default
        notificationCentre.addObserver(self, selector: selector1, name: UIApplication.willResignActiveNotification, object: nil)
        
        let futureVal = defaultData.string(forKey: "futureValM")
        let interestVal =  defaultData.string(forKey: "interestValM")
        let paymentVal = defaultData.string(forKey: "paymentValM")
        let yearsVal = defaultData.string(forKey: "yearsValM")
        
        self.futureValue.text = futureVal
        self.interest.text = interestVal
        self.payment.text = paymentVal
        self.numberOfYears.text = yearsVal
        
        
    }
    @objc func saveDataM(){
        defaultData.set(self.futureValue.text , forKey: "futureValM")
        defaultData.set(self.interest.text, forKey: "interestValM")
        defaultData.set(self.payment.text, forKey: "paymentValM")
        defaultData.set(self.numberOfYears.text, forKey: "yearsValM")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == payment {
            textField.layer.borderWidth = 0
            
        }
        if textField == futureValue {
            textField.layer.borderWidth = 0
        }
        if textField == interest {
            textField.layer.borderWidth = 0
        }
        if textField == numberOfYears {
            textField.layer.borderWidth = 0
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == numberOfYears {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor
        }
        if textField == interest {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor
            
        }
        if textField == futureValue {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor
            
        }
        if textField == payment {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor
            
        }
        
    }
    @objc func dismissKeyboard() {
        //dissmis the keyboard
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let ks = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        var tf: CGRect = (self.tabBarController?.tabBar.frame)!
        tf.origin.y = ks.origin.y - ((self.tabBarController?.tabBar.frame.height)!)
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.tabBarController?.tabBar.frame = tf
        })
        
    }
    
    
    @IBAction func calculateTapped(_ sender: Any) {
        
        let paymentTXT = Double(payment.text!)
        let futureValueTXT = Double(futureValue.text!)
        let interestTXT = Double(interest.text!)
        let numberOfYearsTXT = Double(numberOfYears.text!)
        
        let fincal = FinCalculator()
        
        
        
        if !self.payment.isFirstResponder && !self.futureValue.isFirstResponder && !self.interest.isFirstResponder && !self.numberOfYears.isFirstResponder{
            validateResponder = false
            let alert = UIAlertController(title: "Forgot something?", message: "Please highlight the field you want to be calculated.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }else{
            validateResponder = true
        }
        
        
        
        if validateResponder == true  {
            
            if payment.isFirstResponder {
                if futureValueTXT == nil || interestTXT ==  nil || numberOfYearsTXT == nil  { // if the other fields which are mandatory for the caculation are empty display error message
                    let alert = UIAlertController(title: "Forgot something?", message: "Please fill in the mandatory fields: Future Value, Interest and Compounds .", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                } else{
                    let pmt = fincal.paymentMortgage(presentValue: futureValueTXT!, interest: interestTXT!, numberOfYears: numberOfYearsTXT!)
                    
                    payment.text = String( format: "%.2f", pmt)
                    
                }
            }
            
            if self.numberOfYears.isFirstResponder{
                if futureValueTXT == nil || interestTXT ==  nil || paymentTXT == nil  {
                    let alert = UIAlertController(title: "Forgot something?", message: "Please fill in the mandatory fields: Future Value, Interest and Compounds .", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                } else{
                    
                    let numYears = fincal.yearsMortgage(presentValue: futureValueTXT!, interest: interestTXT!, payment: paymentTXT!)
                    numberOfYears.text = String( format: "%.0f", numYears)
                    
                    
                    
                }
                
            }
        }
    }
    
    
    @IBAction func helpTapped(_ sender: Any) {
        dismissKeyboard()
        popUp = UIView()
        popLable = UILabel()
        dismissB = UIButton()
        let help = FinCalculator()
        let showView = help.popUpView(myView: popUp, MyLable: popLable, myButton: dismissB)
        view.addSubview(showView)
        dismissB.addTarget(self, action: #selector (touch) , for: .touchUpInside)
        
        
    }
    @objc func touch()
    {
        popUp.isHidden = true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true
        case ".":
            let arrayOfCarecters = Array<Character>(textField.text!)
            var  count = 0
            for length in arrayOfCarecters{
                if length == "."{
                    count+=1
                }
                
            }
            if count == 1 {
                let alert = UIAlertController(title: "Warning", message: "Only one decimal point is allowed ", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                return false
                
            } else {
                return true
            }
            
            
        default:
            let array = Array(string)
            if array.count == 0 {
                return true
            }
            let alert = UIAlertController(title: "Warning", message: "Only one decimal point is allowed ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            return false
        }
        
    }
}

