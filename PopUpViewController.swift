//
//  PopUpControllerViewController.swift
//  CW1
//
//  Created by Anton Samuilov on 06/03/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    @IBOutlet weak var PopUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.showAnimate()
        // Do any additional setup after loading the view.
    }
    func showAnimate()
    {
        self.PopUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.PopUpView.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.PopUpView.alpha = 1.0
            self.PopUpView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.PopUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.PopUpView.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.PopUpView.removeFromSuperview()
                }
        });
    }


}
