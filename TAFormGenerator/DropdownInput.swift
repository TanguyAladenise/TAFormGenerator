//
//  DropdownInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 14/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class DropdownInput: TextInput {


    override func setup() {
        super.setup()
        
        let imageView           = UIImageView(image: UIImage(named: "icoAdd"))
        textField.rightView     = imageView
        textField.rightViewMode = UITextFieldViewMode.Always
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }

}
