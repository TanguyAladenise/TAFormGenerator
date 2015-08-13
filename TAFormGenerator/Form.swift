//
//  Form.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 12/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit


class Form {
    
    /// All view contained in the form and identified by an ID
    var formSubviews: Dictionary<String, UIView> = Dictionary<String, UIView>()
    
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
}