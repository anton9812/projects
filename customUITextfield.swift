//
//  customUITextfield.swift
//  CW1
//
//  Created by Anton Samuilov on 16/03/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import UIKit

class customUITextfield: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    //reference to the idea for this solution : //https://forums.developer.apple.com/thread/18660
    //disable copy, paste, cut, select and select all.
    
    
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        if action == #selector(UIResponderStandardEditActions.cut(_:)){
            return false

        }
        if action == #selector(UIResponderStandardEditActions.copy(_:)){
            return false

        }
        if action == #selector(UIResponderStandardEditActions.selectAll(_:)){
            return false

        }
        if action == #selector(UIResponderStandardEditActions.select(_:)){
            return false

        }
        

        return super.canPerformAction(action, withSender: sender)
    }

    
}
