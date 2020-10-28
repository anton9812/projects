//
//  LoansViewController.swift
//  CW1
//
//  Created by Anton Samuilov on 04/03/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class save: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var principalAmount: UITextField!
    @IBOutlet weak var interest: UITextField!
    @IBOutlet weak var payment: UITextField!
    @IBOutlet weak var years: UITextField!
    @IBOutlet weak var futureValue: UITextField!
    
    @IBOutlet weak var calculateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.principalAmount.delegate = self;
        self.payment.delegate = self;
        self.interest.delegate = self;
        self.futureValue.delegate = self;
        self.years.delegate = self;
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        
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
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == principalAmount {
            textField.layer.borderWidth = 3
            textField.layer.borderColor = UIColor.white.cgColor
            textField.layer.cornerRadius = 10
        }
        if textField == interest {
            textField.layer.borderWidth = 3
            textField.layer.borderColor = UIColor.white.cgColor
            textField.layer.cornerRadius = 10
        }
        if textField == futureValue {
            textField.layer.borderWidth = 3
            textField.layer.borderColor = UIColor.white.cgColor
            textField.layer.cornerRadius = 10
        }
        if textField == years {
            textField.layer.borderWidth = 3
            textField.layer.borderColor = UIColor.white.cgColor
            textField.layer.cornerRadius = 10
        }
        if textField == payment {
            textField.layer.borderWidth = 3
            textField.layer.borderColor = UIColor.white.cgColor
            textField.layer.cornerRadius = 10
        }
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == principalAmount {
            textField.layer.borderWidth = 0
            
        }
        if textField == interest {
            textField.layer.borderWidth = 0
        }
        if textField == futureValue {
            textField.layer.borderWidth = 0
        }
        if textField == years {
            textField.layer.borderWidth = 0
        }
        if textField == payment {
            textField.layer.borderWidth = 0
        }
    }
    
    
    @IBAction func calculateButtonTapped(_ sender: Any) {
        
        let paymentTXT = Double(payment.text!)
        let futureValueTXT = Double(futureValue.text!)
        let interestTXT = Double(interest.text!)
        let compountsTXT = Double(years.text!)
        let principalTXT = Double(principalAmount.text!)
        
        let fincal = FinCalculator()
        if futureValue.isFirstResponder{
            if paymentTXT == nil || interestTXT == nil || compountsTXT == nil || principalTXT == nil {
                let alert = UIAlertController(title: "Gorgot something?", message: "Please fill in the mandatory fields: Payment, Interest, Compounds and Principle Amount.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            }else{
                
                let futureWithPayment = fincal.futureValueWithPMT(PMT: paymentTXT!, interest: interestTXT!, Years: compountsTXT!, principelAmount: principalTXT!)
                futureValue.text = String( format: "%.2f", futureWithPayment)
            }
        }
        if payment.isFirstResponder{
            let payment1 = fincal.payment(futureValue: futureValueTXT!, interest: interestTXT!, Years: compountsTXT!, principelAmount: principalTXT!)
            payment.text = String(format: "%.2f", payment1)
            
        }
        
        
    }
    
    
}
