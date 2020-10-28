//
//  SavingsViewController.swift
//  CW1
//
//  Created by Anton Samuilov on 05/03/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class SavingsViewController: UIViewController,UITextFieldDelegate {
    var validateResponder: Bool = false
    @IBOutlet weak var presentValue: UITextField!
    var popUp: UIView!
    var popLable : UILabel!
    var dismissB : UIButton!
    @IBOutlet weak var futureValue: UITextField!
    @IBOutlet weak var years: UITextField! // needs the revived formula
    
    @IBOutlet weak var payment: UITextField!
    @IBOutlet weak var interest: UITextField!
    let defaultData = UserDefaults.standard
    
    
    @IBOutlet weak var helpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presentValue.delegate = self;
        self.years.delegate = self;
        self.interest.delegate = self;
        self.futureValue.delegate = self;
        self.payment.delegate = self;
        payment.layer.cornerRadius = 10.0
        years.layer.cornerRadius = 10.0
        interest.layer.cornerRadius = 10.0
        futureValue.layer.cornerRadius = 10.0
        presentValue.layer.cornerRadius = 10.0
        
        
        payment.setLeftPaddingPoints(10) //adding paddign to the left side of the textfield
        presentValue.setLeftPaddingPoints(10)
        interest.setLeftPaddingPoints(10)
        futureValue.setLeftPaddingPoints(10)
        years.setLeftPaddingPoints(10)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        
        let selector1 = #selector(self.saveDataS)
        let notificationCentre = NotificationCenter.default
        notificationCentre.addObserver(self, selector: selector1, name: UIApplication.willResignActiveNotification, object: nil)
        
        let presentVal = defaultData.string(forKey: "presentValS")
        let futureVal = defaultData.string(forKey: "futureValS")
        let interestVal =  defaultData.string(forKey: "interestValS")
        let paymentVal = defaultData.string(forKey: "paymentValS")
        let yearsVal = defaultData.string(forKey: "yearsValS")
        
        self.presentValue.text = presentVal
        self.futureValue.text = futureVal
        self.interest.text = interestVal
        self.payment.text = paymentVal
        self.years.text = yearsVal
        
        
    }
    @objc func saveDataS(){
        defaultData.set(self.presentValue.text , forKey: "presentValS")
        defaultData.set(self.futureValue.text , forKey: "futureValS")
        defaultData.set(self.interest.text, forKey: "interestValS")
        defaultData.set(self.payment.text, forKey: "paymentValS")
        defaultData.set(self.years.text, forKey: "yearsValS")
    }
    
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == presentValue {
            textField.layer.borderWidth = 0
        }
        if textField == futureValue {
            textField.layer.borderWidth = 0
        }
        if textField == interest {
            textField.layer.borderWidth = 0
        }
        if textField == years {
            textField.layer.borderWidth = 0
        }
        if textField == payment {
            textField.layer.borderWidth = 0
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == presentValue {
            textField.layer.borderWidth = 2 //when begin edititng  set the border width
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor //when begin editting set the border colour
        }
        if textField == interest {
            textField.layer.borderWidth = 2 //when begin edititng  set the border width
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor //when begin editting set the border colour
            
        }
        if textField == futureValue {
            textField.layer.borderWidth = 2 //when begin edititng  set the border width
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor //when begin editting set the border colour
            
        }
        if textField == years {
            textField.layer.borderWidth = 2 //when begin edititng  set the border width
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor //when begin editting set the border colour
            
        }
        
        if textField == payment {
            textField.layer.borderWidth = 2 //when begin edititng  set the border width
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor //when begin editting set the border colour
            
        }
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
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
    
    
    
    @IBAction func calcualteButtonTapped(_ sender: Any){
        
        let presentValueTXT = Double(presentValue.text!)
        let futureValueTXT = Double(futureValue.text!)
        let interestTXT = Double(interest.text!)
        let yearsTXT = Double(years.text!)
        let paymentTXT = Double(payment.text!)
        
        let fincal = FinCalculator()
        
        
        
        if !self.presentValue.isFirstResponder && !self.futureValue.isFirstResponder && !self.interest.isFirstResponder && !self.years.isFirstResponder && !self.payment.isFirstResponder{
            validateResponder = false
            let alert = UIAlertController(title: "Forgot something?", message: "Please highlight the field you want to be calculated.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }else{
            validateResponder = true
        }
        if validateResponder == true {
            
            if futureValue.isFirstResponder {
                if paymentTXT == nil || interestTXT == nil || yearsTXT ==  nil || presentValueTXT == nil  {
                    let alert = UIAlertController(title: "Forgot something?", message: "Please fill in the mandatory fields: Present Value, Interest, Payment and Years .", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                } else{
                    let future =  fincal.futureValueWithPMT(PMT: paymentTXT!, interest: interestTXT!, Years: yearsTXT!, principelAmount: presentValueTXT!)
                    futureValue.text = String( format: "%.2f", future)
                    
                }
            }
            if payment.isFirstResponder{
                if futureValueTXT == nil || interestTXT == nil || yearsTXT ==  nil || presentValueTXT ==  nil {
                    let alert = UIAlertController(title: "Forgot something?", message: "Please fill in the mandatory fields: Present Value, Interest and Compounds .", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                } else{
                    let payment1 = fincal.paymentSavings(futureValue: futureValueTXT!, interest: interestTXT!, Years: yearsTXT!, principelAmount: presentValueTXT!)
                    payment.text = String( format: "%.2f", payment1)
                }
            }
            
            
            
            
            
            
            if interest.isFirstResponder{
                if presentValueTXT == nil || futureValueTXT == nil || yearsTXT ==  nil || paymentTXT == nil{
                    let alert = UIAlertController(title: "Forgot something?", message: "Please fill in the mandatory fields: Present Value, Present Value and Compounds .", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                } else{
                    let interest1 = fincal.interestValue(futureValue: futureValueTXT!, presentValue: presentValueTXT!, Years: yearsTXT!)
                    interest.text = String( format: "%.2f", interest1)
                }
                
                
            }
            if years.isFirstResponder{
                if interestTXT == nil || presentValueTXT == nil || futureValueTXT == nil  || paymentTXT == nil{
                    let alert = UIAlertController(title: "Forgot something?", message: "Please fill in the mandatory fields: Present Value, Present Value and Interest .", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                } else{
                    let years1 = fincal.yearsSavingsWithPayment(interest: interestTXT!, payment: paymentTXT!, futureValue: futureValueTXT!, principelAmount: presentValueTXT!)
                    years.text = String( format: "%.0f", years1)
                }
            }
            
            //let presentValueTXT = Double(presentValue.text!)
            
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
    @objc func touch(){
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

    
    



