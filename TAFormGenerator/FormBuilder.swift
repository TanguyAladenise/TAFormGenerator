//
//  FormBuilder.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 12/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import Foundation


class FormBuilder {
    
    private let form: Form = Form()

    let formView: UIView!
    
    // Layout
    var formViewBottomConstraints: NSLayoutConstraint!
    
    
    init(formView: UIView) {
        self.formView = formView
    }
    
    
    // MARK: - Form building
    
    
    func addSection(sectionHeaderView: UIView, withID sectionID: String) {
        
        if form.validateUniqueID(sectionID, inDictionary: form.formSubviews) {
            insertSectionView(sectionHeaderView, inView: formView)
            form.orderedSectionViews.append(sectionHeaderView)
            
            let sectionWrapper = SectionWrapperView()
            insertSectionView(sectionWrapper, inView: formView)
            
            // Store view in collections for reusability
            form.formSubviews[sectionID] = sectionWrapper
            form.orderedSectionViews.append(sectionWrapper)
        } else {
            NSException(name: "Invalid ID for form", reason: "Section ID is not unique", userInfo: nil).raise()
        }
    }
    
    
    func addInput(inputView: UIView, withID inputID: String, inSectionID sectionID: String) {
        if form.validateUniqueID(inputID, inDictionary: form.formSubviews) {
            if let sectionView = form.formSubviews[sectionID] as? SectionWrapperView {
                insertInput(inputView, inView: sectionView)
                
                // Store view in collections for reusability
                form.formSubviews[inputID] = inputView
                form.orderedFormSubviews.append(inputView)
            }

           
        } else {
            NSException(name: "Invalid ID for form", reason: "Section ID is not unique", userInfo: nil).raise()
        }
    }
    
    
    private func insertInput(inputView: UIView, inView sectionView: SectionWrapperView) {
        sectionView.addSubview(inputView)
        
        setupConstraintsForInput(inputView, inSectionView: sectionView)
    }
    
    
    private func insertSectionView(sectionView: UIView, inView view: UIView) {
        view.addSubview(sectionView)
        
        setupConstraintsForSectionView(sectionView)
    }

    
    // MARK: - Layout logic
    
    
    /**
    Setup constraints for form inputs
    
    :param: inputView View for whom to setup constraints
    */
    private func setupConstraintsForInput(inputView: UIView, inSectionView sectionView: SectionWrapperView) {
    
        // When formViewBottomConstraints is nil this is the first input to be added. So treatment changes. Either pin top to superview or previous input
        if sectionView.bottomConstraint == nil {
            inputView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
        } else {
            let prevInput = form.orderedFormSubviews.last!
            prevInput.superview!.removeConstraint(sectionView.bottomConstraint)
            inputView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: prevInput)
        }
        
        inputView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
        inputView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
        sectionView.bottomConstraint = inputView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
    }
    
    
    /**
    Setup constraints for form sections views
    
    :param: sectionView View for whom to setup constraints
    */
    private func setupConstraintsForSectionView(sectionView: UIView) {
        
        // When formViewBottomConstraints is nil this is the first input to be added. So treatment changes. Either pin top to superview or previous input
        if formViewBottomConstraints == nil || form.orderedSectionViews.count == 0 {
            sectionView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
        } else {
            let prevInput = form.orderedSectionViews.last!
            prevInput.superview!.removeConstraint(formViewBottomConstraints)
            sectionView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: prevInput)
        }
        
        sectionView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
        sectionView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
        formViewBottomConstraints = sectionView.superview!.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: sectionView)
    }
}