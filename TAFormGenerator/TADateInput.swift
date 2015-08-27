//
//  TADateInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 21/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class TADateInput: TADropdownInput {

    var datePickerMode: UIDatePickerMode?
    
    var datePicker: UIDatePicker?
    
    // MARK: - Lifecycle
    
    
    convenience init(datePickerMode: UIDatePickerMode, placeholder: String? = nil) {
        self.init(frame: CGRectZero)
        
        self.datePickerMode = datePickerMode
        self.textField.placeholder = placeholder
    }
    
    
    // MARK: - Must override method
    // FIXME: - Delegate protocol
    
    override func viewForDropdown() -> UIView? {
        datePicker = UIDatePicker(forAutoLayout: ())
        if let mode = datePickerMode {
            datePicker!.datePickerMode = mode
        }
        datePicker!.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        return datePicker
    }

    
    // MARK: Input protocol
    
    
    override func inputValue() -> AnyObject? {
        return datePicker?.date
    }
    
    // MARK: UI picker events
    
    
    func valueChanged(sender: UIDatePicker) {
        
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        if sender.datePickerMode == UIDatePickerMode.Date {
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        } else {
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        }
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.locale    = NSLocale.currentLocale()
        dateFormatter.timeZone  = NSTimeZone.localTimeZone()
        
        var dateString           = dateFormatter.stringFromDate(sender.date)
        dateFormatter.dateFormat = "eee"
        dateString = "\(dateFormatter.stringFromDate(sender.date)) \(dateString)"
        textField.text = dateString
    }
}
