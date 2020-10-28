//
//  CUSTOMUITEXT.swift
//  CW1
//
//  Created by Anton Samuilov on 16/03/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import Foundation
import UIKit

class CustomUITextfield : UITextField{
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == "paste:" {
            return false
        }

        return super.canPerformAction(action, withSender: sender)
    }
}
