//
//  Form.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 12/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit


class TAForm {
    
    /// All view contained in the form and identified by an ID
    var formSubviews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    
    /// All form subview ordered by time of insertion
    var orderedFormSubviews: [UIView] = []
    
    /// Section views references stored in order of appearance (usefull for layout)
    var orderedSectionViews: [UIView] = []
    
    
    /**
    Make sure ID use for form is unique. ID is used to fetch input values and other manipulation
    
    :param: id         ID to test
    :param: dictionary Dicionnary to test
    
    :returns: Return true if ID is unique. false if ID already used
    */
    func validateUniqueID(id: String, inDictionary dictionary: Dictionary<String, AnyObject>) -> Bool {
        if let value: AnyObject = dictionary[id] {
            return false
        }
        
        return true
    }
    
    
    /**
    Return a value for a given ID
    
    :param: inputID Input ID to fetch value
    
    :returns: Value of input
    */
    func valueForInput(inputID: String) -> AnyObject? {
        if let input = formSubviews[inputID] as? TAInputProtocol {
            // FIXME: - to be removed
            println(input.inputValue())
            return input.inputValue()
        } else {
            println("Validation for fieldID \(inputID) impossible. Input doest not conform to protocol TAInputProtocol")
            return nil
        }
    }
}