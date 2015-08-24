//
//  FormViewController.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 12/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    
    var formBuilder: FormBuilder!
    
    // UI
    
    /// The scroll view containing the form. Instantiated in viewDidLoad()
    private var scrollView: UIScrollView!
    private lazy var formView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }()
    /// Button always at the bottom of the of the form. For validating
    private lazy var validateFormButton: UIButton = {
        let button: UIButton   = UIButton.buttonWithType(.Custom) as! UIButton
        button.backgroundColor = UIColor.blueColor()
        button.setTitle(NSLocalizedString("Confirm", comment: ""), forState: .Normal)
        button.addTarget(self, action: "validateButtonPressed", forControlEvents: .TouchUpInside)
        return button
    }()
    
    
    
    // Layout related properties
    
    private var didSetupConstraints: Bool = false
    // Margins within scrollView
    let kFORM_MARGIN: CGFloat = 12
    
    
    // MARK: - Lifecycle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        view.addSubview(scrollView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "endEditing:")
        scrollView.addGestureRecognizer(tapGesture)
        
        scrollView.addSubview(formView)
        scrollView.addSubview(validateFormButton)
        
        // Must be init after formView and scrollview
        formBuilder = FormBuilder(formView: formView)
    }
    
    
    // MARK: - Layout
    
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            // ScrollView takes whole screen
            scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            
            formView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Bottom)
            formView.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: scrollView)
            
            // Validation btn sticks at the bottom and is has big as the scrollview minus the margins
            validateFormButton.autoSetDimension(ALDimension.Width, toSize: CGRectGetWidth(view.frame) - kFORM_MARGIN * 2)
            validateFormButton.autoAlignAxisToSuperviewAxis(ALAxis.Vertical)
            validateFormButton.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: kFORM_MARGIN)
            validateFormButton.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: formView, withOffset: kFORM_MARGIN)

            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    
    // MARK: - UI Actions
    
    
    func endEditing(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    
}
