//
//  TAFormValidator.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 26/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import Foundation


class TAFormValidator {
    
    private var form: TAForm!
    
    
    private var inputValidators: [Dictionary<String, AnyObject>] = []
    
    
    init(form: TAForm) {
        self.form = form
    }
    
    
    // MARK: - Validation
    
    
    /**
    Add a validator to the form
    
    :param: inputID   String identifying an input
    :param: fieldValidator The validator for given full
    */
    func addValidator(inputID: String, inputValidator: TAInputValidator) {
        inputValidators.append(["inputID" : inputID, "inputValidator" : inputValidator])
    }
    
    
    /**
    Validate form
    
    :returns: Boolean indicating if form is valid. Error for invalid information (Optional). String with field ID concerned by this error
    */
    func validateForm() -> (Bool, String?, NSError?) {
        
        for (aValidator) in inputValidators {
            
            if let inputID = aValidator["inputID"] as? String, let validator = aValidator["inputValidator"] as? TAInputValidator {
                var result: (valid: Bool, error: NSError?)
                if let input = form.inputWithID(inputID) as? TAInputValidatorProtocol {
                    result = input.validateInput(validator)
                } else {
                    let value: AnyObject? = form.valueForInput(inputID)
                    result = validator.validate(value)
                }
                if !result.valid {
                    return (result.valid, inputID, result.error)
                }
            } else {
                println("Validation for fieldID \(aValidator) impossible.")
            }
        }
        
        return (true, nil, nil)
    }
}