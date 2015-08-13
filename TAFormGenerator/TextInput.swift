//
//  TextInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 13/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class TextInput: UIView {

    
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
        self.textField.backgroundColor = UIColor.blueColor()
    }
    
    
    // MARK: - Layout
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            textField.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
}
