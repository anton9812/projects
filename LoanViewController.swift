//
//  LoanViewController.swift
//  CW1
//
//  Created by Anton Samuilov on 06/03/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class LoanViewController: UIViewController, UITextFieldDelegate {
    var popUp: UIView!
    var popLable : UILabel!
    var dismissB : UIButton!
    var validateResponder: Bool = true
    @IBOutlet weak var payment: UITextField!
    @IBOutlet weak var years: UITextField!
    @IBOutlet weak var interest: UITextField!
    @IBOutlet weak var loanAmount: UITextField!
    let defaultData = UserDefaults.standard
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var calculateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.payment.delegate = self;
        self.years.delegate = self;
        self.interest.delegate = self;
        self.loanAmount.delegate = self;
        payment.layer.cornerRadius = 10.0
        years.layer.cornerRadius = 10.0
        interest.layer.cornerRadius = 10.0
        loanAmount.layer.cornerRadius = 10.0
        
        
        payment.setLeftPaddingPoints(10) //adding paddign to the left side of the textfield
        years.setLeftPaddingPoints(10)
        interest.setLeftPaddingPoints(10)
        loanAmount.setLeftPaddingPoints(10)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let selector1 = #selector(self.saveDataL)
        let notificationCentre = NotificationCenter.default
        notificationCentre.addObserver(self, selector: selector1, name: UIApplication.willResignActiveNotification, object: nil)
        
        let interestVal =  defaultData.string(forKey: "interestValL")
        let paymentVal = defaultData.string(forKey: "paymentValL")
        let yearsVal = defaultData.string(forKey: "yearsValL")
        let loanVal = defaultData.string(forKey: "loanValL")
        
        self.loanAmount.text = loanVal
        self.interest.text = interestVal
        self.payment.text = paymentVal
        self.years.text = yearsVal
        
        
    }
    @objc func saveDataL(){
        defaultData.set(self.years.text , forKey: "yearsValL")
        defaultData.set(self.interest.text, forKey: "interestValL")
        defaultData.set(self.payment.text, forKey: "paymentValL")
        defaultData.set(self.loanAmount.text, forKey: "loanValL")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == payment {
            textField.layer.borderWidth = 0
            
        }
        if textField == years {
            textField.layer.borderWidth = 0
        }
        if textField == interest {
            textField.layer.borderWidth = 0
        }
        if textField == loanAmount {
            textField.layer.borderWidth = 0
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == loanAmount {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor
        }
        if textField == interest {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor
            
        }
        if textField == years {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor
            
        }
        if textField == payment {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor
            
        }
        
    }
    
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let ks = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        var tf: CGRect = (self.tabBarController?.tabBar.frame)!
        tf.origin.y = ks.origin.y - ((self.tabBarController?.tabBar.frame.height)!)
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.tabBarController?.tabBar.frame = tf
        })
        
    }
    @objc func dismissKeyboard() {
        //dissmis the keyboard
        view.endEditing(true)
    }
    
    
    
    
    
    
    @IBAction func calculateTapped(_ sender: Any) {
        
        let paymentTXT = Double(payment.text!)
        let yearsTXT = Double(years.text!)
        let interestTXT = Double(interest.text!)
        let loanAmountTXT = Double(loanAmount.text!)
        
        let fincal = FinCalculator()
        
        
        if !self.loanAmount.isFirstResponder  && !self.interest.isFirstResponder && !self.years.isFirstResponder && !self.payment.isFirstResponder{
            validateResponder = false
            let alert = UIAlertController(title: "Forgot something?", message: "Please highlight the field you want to be calculated.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }else{
            validateResponder = true
        }
        if validateResponder == true {
            
            if payment.isFirstResponder {
                if yearsTXT == nil || interestTXT ==  nil || loanAmountTXT == nil  {
                    let alert = UIAlertController(title: "Forgot something?", message: "Please fill in the mandatory fields: Years, Interest and Loan Amount .", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                } else{
                    let pmt = fincal.paymentLoan(loanAmount: loanAmountTXT!, interest: interestTXT!, numberOfYears: yearsTXT!)
                    
                    payment.text = String( format: "%.2f", pmt)
                    
                }
            }
            if years.isFirstResponder{
                if loanAmountTXT == nil || interestTXT ==  nil || paymentTXT == nil  {
                    let alert = UIAlertController(title: "Forgot something?", message: "Please fill in the mandatory fields: Loan Amount, Interest and Payment .", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                } else{
                    
                    let numYears = fincal.yearsLoan(loanAmount: loanAmountTXT!, interest: interestTXT!, payment: paymentTXT!)
                    years.text = String( format: "%.0f", numYears)
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
            let alert = UIAlertController(title: "Warning", message: "Only one decimal point is allowed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            return false
        }
        
    }
    
    
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
}









