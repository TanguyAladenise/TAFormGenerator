//
//  TextInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 13/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class TextInput: UIView, UITextFieldDelegate {

    
    let textField: UITextField! = UITextField()

    var didSetupConstraints: Bool = false

    
    // MARK: - Lifecycle
    
    
    convenience init(placeholder: String?) {
        self.init(frame: CGRectZero)
        
        textField.placeholder = placeholder
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        setup()
    }
    
    
    func setup() {
        println("setup")
        
        addSubview(textField)
        self.textField.backgroundColor = UIColor.clearColor()
        self.textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.textField.returnKeyType   = UIReturnKeyType.Done
        self.textField.delegate        = self
        
        self.backgroundColor           = UIColor.whiteColor()
    }
    
    
    // MARK: - Layout
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            autoSetDimension(ALDimension.Height, toSize: 50)
            textField.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 15, 0, 15))
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    
    // MARK: - Text field delegate
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.returnKeyType == UIReturnKeyType.Done) {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
}
