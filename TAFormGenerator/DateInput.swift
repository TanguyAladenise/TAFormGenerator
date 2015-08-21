
//
//  DateInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 21/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class DateInput: DropdownInput {

    var datePickerMode: UIDatePickerMode?
    
    
    // MARK: - Lifecycle
    
    
    convenience init(datePickerMode: UIDatePickerMode, placeholder: String? = nil) {
        self.init(frame: CGRectZero)
        
        self.datePickerMode = datePickerMode
        self.textField.placeholder = placeholder
    }
    
    
    // MARK: - Must override method
    // FIXME: - Delegate protocol
    
    override func viewForDropdown() -> UIView? {
        let picker        = UIDatePicker(forAutoLayout: ())
        if let mode = datePickerMode {
            picker.datePickerMode = mode
        }
        picker.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        return picker
    }

    
    // MARK: UI picker events
    
    
    func valueChanged(sender: UIDatePicker) {
        
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        if sender.datePickerMode == UIDatePickerMode.Date {
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        } else {
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        }
        dateFormatter.dateStyle           = NSDateFormatterStyle.MediumStyle
        dateFormatter.locale              = NSLocale.currentLocale()
        dateFormatter.timeZone            = NSTimeZone.localTimeZone()
        var dateString = dateFormatter.stringFromDate(sender.date)
        
        dateFormatter.dateFormat = "eee"
        dateString = "\(dateFormatter.stringFromDate(sender.date)) \(dateString)"
        textField.text = dateString
    }
}
