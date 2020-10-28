//
//  ViewController.swift
//  CW1
//
//  Created by Anton Samuilov on 18/02/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class CompoundSavingsViewController: UIViewController,UITextFieldDelegate {
    var popUp: UIView!
    var popLable: UILabel!
    var dismissB: UIButton!
    
    var validateResponder: Bool = false
    @IBOutlet weak var paymentPerYear: UITextField!
    @IBOutlet weak var interest: UITextField!
    @IBOutlet weak var futureValue: UITextField!
    @IBOutlet weak var presentValue: UITextField!
    let defaultData = UserDefaults.standard
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var calculateBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presentValue.delegate = self; //setting the delegate to the textfields
        self.paymentPerYear.delegate = self;
        self.interest.delegate = self;
        self.futureValue.delegate = self;
        
        paymentPerYear.layer.cornerRadius = 10.0 //setting the corner radius of the fields
        interest.layer.cornerRadius = 10.0
        futureValue.layer.cornerRadius = 10.0
        presentValue.layer.cornerRadius = 10.0
        
       // solution for spacing in the textfields inspired by this post. https://stackoverflow.com/questions/25367502/create-space-at-the-beginning-of-a-uitextfield
        
        paymentPerYear.setLeftPaddingPoints(10) //adding paddign to the left side of the textfield
        presentValue.setLeftPaddingPoints(10)
        interest.setLeftPaddingPoints(10)
        futureValue.setLeftPaddingPoints(10)
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap) //addin the gesture recognition to the view
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil) //adding an observer to the keyboardWillShow notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //adding an observer to the keyboardWillHide notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //frame height change
        
        let selector1 = #selector(self.saveDataC)
        let notificationCentre = NotificationCenter.default
        notificationCentre.addObserver(self, selector: selector1, name: UIApplication.willResignActiveNotification, object: nil)
        
        let presentVal = defaultData.string(forKey: "presentValCS") //retrieving the default data for the textfields
        let futureVal = defaultData.string(forKey: "futureValCS")
        let interestVal =  defaultData.string(forKey: "interestValCS")
        let paymentVal = defaultData.string(forKey: "paymentValCS")
        
        
        self.presentValue.text = presentVal
        self.futureValue.text = futureVal
        self.interest.text = interestVal
        self.paymentPerYear.text = paymentVal
        
        
        
    }
    @objc func saveDataC(){
        defaultData.set(self.presentValue.text , forKey: "presentValCS") //setting the default data for the textfields
        defaultData.set(self.futureValue.text , forKey: "futureValCS")
        defaultData.set(self.interest.text, forKey: "interestValCS")
        defaultData.set(self.paymentPerYear.text, forKey: "paymentValCS")
    }
    
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == presentValue { //when stop editing a field set the border width to non
            
            textField.layer.borderWidth = 0
            
            
        }
        if textField == futureValue {
            textField.layer.borderWidth = 0
        }
        if textField == interest {
            textField.layer.borderWidth = 0
        }
        if textField == paymentPerYear {
            textField.layer.borderWidth = 0
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == presentValue {
            textField.layer.borderWidth = 2 //when begin edititng  set the border width
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor //when begin editting set the border colour
            
        }
        if textField == interest {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor
            
        }
        if textField == futureValue {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor
            
        }
        if textField == paymentPerYear {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.init(red: 0/255,green: 99/255,blue: 236/255,alpha: 1).cgColor
            
        }
        
    }
    @objc func dismissKeyboard() {
        // hide the keyboard
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let ks = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        var tf: CGRect = (self.tabBarController?.tabBar.frame)! // get the instance of tabbar and store it on a a variable
        tf.origin.y = ks.origin.y - ((self.tabBarController?.tabBar.frame.height)!) //tabbar possition change which is keyboard height minus the tabbar height
        UIView.animate(withDuration: 0.25, animations: {() -> Void in //move the keyboard up.
            self.tabBarController?.tabBar.frame = tf
        })
        
    }
    
    
    
    
    @IBAction func calcualteButtonTapped(_ sender: Any) {
        let presentValueTXT = Double(presentValue.text!) //store the value of the textview on a variable
        let futureValueTXT = Double(futureValue.text!)
        let interestTXT = Double(interest.text!)
        let compountsTXT = Double(paymentPerYear.text!)
        
        let fincal = FinCalculator() // creating an instance of the calculator class
        
        
        if !self.presentValue.isFirstResponder && !self.futureValue.isFirstResponder && !self.interest.isFirstResponder && !self.paymentPerYear.isFirstResponder {
            validateResponder = false //if non of the fields are isFirstResponder they have not highlighted a field which is mandatory for the calculation
            let alert = UIAlertController(title: "Forgot something?", message: "Please highlight the field you want to be calculated.", preferredStyle: .alert) //show an alert to notify the user
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }else{
            validateResponder = true // if there is first responder set true
        }
        
        if validateResponder == true { // if true continue
            
            
            if presentValue.isFirstResponder { //if present value is first responder execute this
                if futureValueTXT == nil || interestTXT == nil || compountsTXT ==  nil { //check of the other 3 fields are empty
                    
                     let alert = UIAlertController(title: "Forgot something?", message: "Please fill in the mandatory fields: Future Value, Interest and Payments .", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                } else{
                    let deposit = fincal.PresentValue(futureValue: futureValueTXT!, interest: interestTXT!, Years: compountsTXT!)
                    presentValue.text = String( format: " %.2f", deposit)
                }
            }
            if futureValue.isFirstResponder{
                if presentValueTXT == nil || interestTXT == nil || compountsTXT ==  nil { //check of the other 3 fields are empty
                    let alert = UIAlertController(title: "Forgot something?", message: "Please fill in the mandatory fields: Present Value, Interest and Payments .", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                } else{
                    let future = fincal.FutureValue(presentValue: presentValueTXT!, interest: interestTXT!, Years: compountsTXT!)
                    futureValue.text = String( format: " %.2f", future) // round up the value to 2 decimal places
                }
            }
            if interest.isFirstResponder{
                if presentValueTXT == nil || futureValueTXT == nil || compountsTXT ==  nil { //check of the other 3 fields are empty
                    let alert = UIAlertController(title: "Forgot something?", message: "Please fill in the mandatory fields: Present Value, Future Value and Payments .", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                } else{
                    let interest1 = fincal.interestValue(futureValue: futureValueTXT!, presentValue: presentValueTXT!, Years: compountsTXT!)
                    interest.text = String( format: "%.1f", interest1)
                }
                
                
            }
            if paymentPerYear.isFirstResponder{
                if  futureValueTXT == nil ||  presentValueTXT ==  nil || interestTXT ==  nil { //check of the other 3 fields are empty
                    let alert = UIAlertController(title: "Forgot something?", message: "Please fill in the mandatory fields: Present Value, Future Value and Interest .", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                } else{
                    let compound = fincal.compoundsPerYear(futureValue: futureValueTXT!, presentValue: presentValueTXT!, interest: interestTXT!)
                    paymentPerYear.text = String( format: "%.0f", compound) // round up the value to 0 decimal places in order to despay full number since you cannot make half a payment.
                }
            }
        }
        
    }
    
    @IBAction func helpTapped(_ sender: Any) {
        dismissKeyboard() // if the keyboard is  show dissmis it
        popUp = UIView() //creat an instaance of the view,label and button
        popLable = UILabel()
        dismissB = UIButton()
        let help = FinCalculator() // create an instance of the calculator class
        
        let showView = help.popUpView(myView: popUp, MyLable: popLable, myButton: dismissB) // call the function
        view.addSubview(showView) // add to the view
        dismissB.addTarget(self, action: #selector (touch) , for: .touchUpInside) // add function to the button
        
        
        
    }
    @objc func touch(){
        popUp.isHidden = true // hide the view when dissmiss is clicked
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        //the inspiration for this solution came from this website : https://stackoverflow.com/questions/26566844/limiting-user-input-to-a-valid-decimal-number-in-swift
        
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9": // if the values are 0 to 9  return true meaning there is no double up of decimal separator
           
            return true
            
        case ".":
            let arrayOfCarecters = Array<Character>(textField.text!) // if decimal separator apears create an array of characters.
            var  count = 0 //keep track of the decimal separator
            for length in arrayOfCarecters{
                if length == "."{ // if they are present add up to the count
                    count+=1
                }
                
            }
            if count == 1 { // if count is more than one display the messege
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
extension UITextField {
    
    func setLeftPaddingPoints( amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height)) //width is set to the amount passed when called and the heihgt is se to the fram of the textfield
        self.leftView = paddingView
        self.leftViewMode = .always
        
    }
    
}

