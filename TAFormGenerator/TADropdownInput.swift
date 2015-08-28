//
//  TADropdownInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 14/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class TADropdownInput: TATextInput {

    var menuWrapper: UIView?
    
    var menuIsCollapsed: Bool = true
    var menuHeightConstraint: NSLayoutConstraint!
    
    var isEditable = false
    
    // MARK: - Lifecycle
    
    
    override func setup() {
        super.setup()
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let rightView = UIButton.buttonWithType(.Custom) as! UIButton
        rightView.setImage(UIImage(named: "icoExpand"), forState: .Normal)
        rightView.setImage(UIImage(named: "icoCollapse"), forState: .Selected)
        rightView.addTarget(self, action: "openMenuBtnPressed", forControlEvents: .TouchUpInside)
        rightView.frame     = CGRectMake(0, 0, 50, 50)
        textField.rightView = rightView

        textField.rightViewMode = UITextFieldViewMode.Always
    }
    
    
    // MARK: - UI Actions
    
    
    func openMenuBtnPressed() {
        if menuIsCollapsed {
            openMenu()
        } else {
            closeMenu()
        }
    }
    
    
    // MARK: - TextField delegate
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if !isEditable || menuIsCollapsed {
            openMenuBtnPressed()
        }
        
        return isEditable
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
            (textField.rightView as! UIButton).selected = true
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
        (textField.rightView as! UIButton).selected = false
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
