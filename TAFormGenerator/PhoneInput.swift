//
//  PhoneInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 13/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class PhoneInput: TextInput {

    override func setup() {
        super.setup()
        
        textField.keyboardType = UIKeyboardType.PhonePad
    }

}
