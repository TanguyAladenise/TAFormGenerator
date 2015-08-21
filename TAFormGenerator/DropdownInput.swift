//
//  DropdownInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 14/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class DropdownInput: TextInput {

    var menuWrapper: UIView?
    var picker: UIPickerView?
    
    var menuIsCollapsed: Bool = true
    var menuHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Lifecycle
    
    
    override func setup() {
        super.setup()
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
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
            self.insertSubview(menuWrapper!, atIndex: 0)
            menuWrapper!.autoPinEdgeToSuperviewEdge(.Leading)
            menuWrapper!.autoPinEdgeToSuperviewEdge(.Trailing)
            menuHeightConstraint = menuWrapper!.autoSetDimension(.Height, toSize: 0)
            textField.superview!.removeConstraint(textFieldBottomConstraint)
            menuWrapper!.autoPinEdge(.Top, toEdge: .Bottom, ofView: textField)
            menuWrapper!.autoPinEdgeToSuperviewEdge(.Bottom)
        }
        
        if menuIsCollapsed {
            menuHeightConstraint.constant = 0
            layoutIfNeeded()
            menuHeightConstraint.constant = 160
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.layoutIfNeeded()
            }, completion: { (completion: Bool) -> Void in
                self.menuIsCollapsed = false
            })
        }
    }
    
    
    func closeMenu() {
        menuHeightConstraint.constant = 0
        self.layoutIfNeeded()
        self.menuIsCollapsed = true
    }
    
    
    func createMenu() {
        menuWrapper                  = UIView(forAutoLayout: ())
        menuWrapper!.backgroundColor = UIColor.whiteColor()
        menuWrapper!.clipsToBounds   = true
        
        if let view = viewForDropdown() {
            // Layout setup
            menuWrapper!.addSubview(view)
            view.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
            

    }
    
    /**
    View to insert in dropdown wrapper. Call only once when needed for display
    
    :returns: View for dropdown
    */
    func viewForDropdown() -> UIView? {
        // TO OVERRIDE
        return nil
    }


}
