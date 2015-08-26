//
//  TATextInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 13/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

protocol TAInputProtocol {
    func inputValue() -> String?
}


class TATextInput: UIView, TAInputProtocol, UITextFieldDelegate {

    
    let textField: UITextField! = UITextField()
    private var border: UIView  = UIView()
    
    var didSetupConstraints: Bool = false

    var textFieldTopConstraint: NSLayoutConstraint!
    var textFieldBottomConstraint: NSLayoutConstraint!
    
    
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
        addSubview(textField)
        textField.backgroundColor = UIColor.clearColor()
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField.returnKeyType   = UIReturnKeyType.Done
        textField.delegate        = self
        
        backgroundColor           = UIColor.whiteColor()
        
        border.backgroundColor = UIColor ( red: 0.7507, green: 0.7507, blue: 0.7507, alpha: 0.35 )
        insertSubview(border, aboveSubview: textField)
    }
    
    
    // MARK: - Protocol
    
    
    func inputValue() -> String? {
        if textField.text == "" {
            return nil
        } else {
            return textField.text
        }
    }
    
    
    // MARK: - Layout
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            autoSetDimension(.Height, toSize: 50, relation: NSLayoutRelation.GreaterThanOrEqual)
            textField.autoSetDimension(.Height, toSize: 50, relation: NSLayoutRelation.GreaterThanOrEqual)
            
            textFieldTopConstraint    = textField.autoPinEdgeToSuperviewEdge(.Top)
            textFieldBottomConstraint = textField.autoPinEdgeToSuperviewEdge(.Bottom)
            textField.autoPinEdgeToSuperviewEdge(.Left, withInset: 15)
            textField.autoPinEdgeToSuperviewEdge(.Right, withInset: 15)

            border.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: border.superview)
            border.autoSetDimension(ALDimension.Height, toSize: 1)
            border.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
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
