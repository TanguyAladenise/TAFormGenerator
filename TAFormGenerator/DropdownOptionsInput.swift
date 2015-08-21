//
//  DropdownOptionsInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 21/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class DropdownOptionsInput: DropdownInput, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var options: [String] = [NSLocalizedString("None", comment: "No choice in a list")]

    
    // MARK: - Lifecycle
    

    convenience init(dropdownOptions: [String], placeholder: String? = nil) {
        self.init(frame: CGRectZero)
        
        self.options += dropdownOptions
        self.textField.placeholder = placeholder
    }

    
    // MARK: - Must override method
    // FIXME: - Delegate protocol
    
    override func viewForDropdown() -> UIView? {
        let picker        = UIPickerView(forAutoLayout: ())
        picker.delegate   = self
        picker.dataSource = self
        return picker
    }
    
    
    // MARK: - Picker datasource
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // MARK: - Picker delegate
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return options[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = options[row]
    }
}
