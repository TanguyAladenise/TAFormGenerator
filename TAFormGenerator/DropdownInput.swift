//
//  DropdownInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 14/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class DropdownInput: TextInput, UIPickerViewDataSource, UIPickerViewDelegate {

    var options: [String] = [NSLocalizedString("None", comment: "No choice in a list"), "dzadz", "dsw", "vcx", "juy", "=m", "45", "dzwxwxxwadz", ]
    var menuWrapper: UIView?
    var picker: UIPickerView?
    
    var menuIsCollapsed: Bool = true
    
    // MARK: - Lifecycle
    
    
    convenience init(dropdownOptions: [String]) {
        self.init(frame: CGRectZero)
        
        self.options += dropdownOptions
    }

    
    override func setup() {
        super.setup()
        
        let imageView           = UIImageView(image: UIImage(named: "icoAdd"))
        textField.rightView     = imageView
        textField.rightViewMode = UITextFieldViewMode.Always
        
        textField.backgroundColor = UIColor.purpleColor()
    }
    
    
    // MARk: - TextField delegate
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if menuIsCollapsed {
            openMenu()
        } else {
            closeMenu()
        }
        
        return false
    }
    
    
    // MARk: - Dropdown menu
    
    
    func openMenu() {
        if menuWrapper == nil {
            createMenu()
        }
        
        if menuIsCollapsed {
            self.addSubview(menuWrapper!)
            menuWrapper!.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
            menuWrapper!.autoPinEdge(.Top, toEdge: .Bottom, ofView: textField)
            menuWrapper!.autoSetDimension(.Height, toSize: 160)
            layoutIfNeeded()
            menuWrapper!.alpha = 0
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.menuWrapper!.alpha = 1
            }, completion: { (completion: Bool) -> Void in
                self.menuIsCollapsed = false
            })
        }
        
    }
    
    
    func closeMenu() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.menuWrapper!.alpha = 0
        }, completion: { (completion: Bool) -> Void in
            self.menuWrapper!.removeFromSuperview()
            self.menuIsCollapsed = true
        })
    }
    
    
    func createMenu() {
        menuWrapper                  = UIView()
        menuWrapper!.backgroundColor = UIColor.whiteColor()
        menuWrapper!.clipsToBounds   = true
        
        let picker        = UIPickerView()
        picker.delegate   = self
        picker.dataSource = self
        menuWrapper!.addSubview(picker)
        
        // Layout setup
        picker.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
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
