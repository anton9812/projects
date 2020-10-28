//
//  SavingsViewController.swift
//  CW1
//
//  Created by Anton Samuilov on 18/02/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class LoanViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    
    
    
}
