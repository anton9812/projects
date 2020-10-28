//
//  textfield.swift
//  CW2
//
//  Created by Anton Samuilov on 31/05/2020.
//  Copyright © 2020 Anton Samuilov. All rights reserved.
//

import Foundation
import UIKit

enum ValueType: Int {
    case none
    case onlyLetters
    case onlyNumbers
}
import UIKit

private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    //Stack Overflow. (n.d.). ios - Set the maximum character length of a UITextField. [online] Available at: https://stackoverflow.com/questions/433337/set-the-maximum-character-length-of-a-uitextfield/48710801 [Accessed 1 Jun. 2020].

    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }

    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }

        let selection = selectedTextRange

        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)

        selectedTextRange = selection
    }
}
