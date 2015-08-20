//
//  LinksInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 20/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class LinksInput: TextInput {

    var linksWrapper: UIView = UIView(forAutoLayout: ())
    
    var linksWrapperBottomConstraint: NSLayoutConstraint!
    
    weak var target: UIViewController?

    // MARK: - Lifecycle
    
    
    convenience init(placeholder: String? = nil, target: UIViewController) {
        self.init(frame: CGRectZero)
        
        self.textField.placeholder = placeholder
        self.target = target
    }
    
    
    override func setup() {
        super.setup()
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.addSubview(linksWrapper)
        
        let imageView                = UIImageView(image: UIImage(named: "icoAdd"))
        self.textField.rightView     = imageView
        self.textField.rightViewMode = UITextFieldViewMode.Always
    }
    
    
    // MARK: - UI actions
    
    
    func addLink() {
        println("add link")
        let vc = AddLinkViewController(nibName: "AddLinkViewController", bundle: nil)
        if let target = target {
            target.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    
    // MARk: - TextField delegate
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        addLink()
        return false
    }
    
    
    // MARK: - Layout
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            super.updateConstraints()

            textField.superview!.removeConstraint(textFieldTopConstraint)
            linksWrapper.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            linksWrapper.autoPinEdge(.Bottom, toEdge: .Top, ofView: textField)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }

}
