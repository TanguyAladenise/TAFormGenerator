//
//  TAURLInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 21/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class TAURLInput: TATextInput {
    
    let preset = "http://www."

    override func setup() {
        super.setup()
        
        textField.keyboardType = UIKeyboardType.URL
    }

    
    // MARK: - Inpur protocol
    
    
    override func inputValue() -> String? {
        if textField.text == preset {
            return nil
        } else {
            return super.inputValue()
        }
    }
    
    
    // MARK: - Textfield delegate
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = preset
        
        return true
    }
    
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField.text == preset {
            textField.text = ""
        }
        
        return true
    }
}
