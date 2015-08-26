//
//  TAFormBuilder.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 12/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import Foundation

private enum TAFloatPosition: Int {
    case First
    case Middle
    case Last
}

class TAFormBuilder {
    
    private var form: TAForm!
    let formView: UIView!
    
    // Layout
    var formViewBottomConstraints: NSLayoutConstraint!
    
    
    init(form: TAForm, formView: UIView) {
        self.form     = form
        self.formView = formView
    }
    
    
    // MARK: - Form building
    
    
    func addSection(sectionHeaderView: UIView, withID sectionID: String) {
        if validateID(sectionID, inDictionary: form.formSubviews) {
            insertSectionView(sectionHeaderView, inView: formView)
            form.orderedSectionViews.append(sectionHeaderView)
            
            let sectionWrapper = TASectionWrapperView()
            sectionWrapper.clipsToBounds = true
            insertSectionView(sectionWrapper, inView: formView)
            
            // Store view in collections for reusability
            form.formSubviews[sectionID] = sectionWrapper
            form.orderedSectionViews.append(sectionWrapper)
        }
    }
    
    
    func addInput(inputView: UIView, withID inputID: String, inSectionID sectionID: String) {
        if validateID(inputID, inDictionary: form.formSubviews) {
            if let sectionView = form.formSubviews[sectionID] as? TASectionWrapperView {
                insertInput(inputView, inView: sectionView)
                
                // Store view in collections for reusability
                form.formSubviews[inputID] = inputView
                form.orderedFormSubviews.append(inputView)
            } else {
                NSException(name: "Invalid section", reason: "No section view found with ID", userInfo: nil).raise()
            }
        }
    }
    
    
    func addFloatingInputs(inputViews: [UIView], withMatchingIDs inputIDs: [String], inSectionID sectionID: String, atPositions positions: CGFloat...) {
        if inputViews.count == inputIDs.count && inputViews.count == positions.count && inputIDs.count == positions.count {
            if let sectionView = form.formSubviews[sectionID] as? TASectionWrapperView {
                for (index, inputView) in enumerate(inputViews) {
                    let inputID  = inputIDs[index]
                    let position = positions[index]
                    if validateID(inputID, inDictionary: form.formSubviews) {
                        var multiplier: CGFloat = position
                        var floatPosition = TAFloatPosition.Middle
                        if index == 0 {
                            floatPosition = .First
                        } else if index == inputViews.count - 1 {
                            floatPosition = .Last
                        }
                        
                        if index > 0 {
                            multiplier = position - positions[index - 1]
                        }
                        insertFloatingInput(inputView, withMultiplier: multiplier, inView: sectionView, floatPosition: floatPosition)
                        
                        // Store view in collections for reusability
                        form.formSubviews[inputID] = inputView
                        form.orderedFormSubviews.append(inputView)
                    }
                }
            } else {
                NSException(name: "Invalid section", reason: "No section view found with ID", userInfo: nil).raise()
            }
        } else {
            NSException(name: "Inconstancy number of values", reason: "Each parameters should have the same number of values", userInfo: nil).raise()
        }
    }
    
    
    private func insertInput(inputView: UIView, inView sectionView: TASectionWrapperView) {
        sectionView.insertSubview(inputView, atIndex: 0)
        
        setupConstraintsForInput(inputView, inSectionView: sectionView)
    }
    
    
    private func insertFloatingInput(inputView: UIView, withMultiplier multiplier: CGFloat, inView sectionView: TASectionWrapperView, floatPosition: TAFloatPosition) {
        sectionView.addSubview(inputView)
        
        setupConstraintsForFloatingInput(inputView, inSectionView: sectionView, withMultiplier: multiplier, floatPosition: floatPosition)
    }
    
    
    private func insertSectionView(sectionView: UIView, inView view: UIView) {
        view.addSubview(sectionView)
        
        setupConstraintsForSectionView(sectionView)
    }

    
    private func validateID(id: String, inDictionary dictionary: Dictionary<String, AnyObject>) -> Bool {
        if form.validateUniqueID(id, inDictionary: dictionary) {
            return true
        } else {
            NSException(name: "Invalid ID for form", reason: "ID is not unique", userInfo: nil).raise()
        }
        
        return false
    }
    
    
    // MARK: - Layout logic
    
    
    /**
    Setup constraints for form inputs
    
    :param: inputView View for whom to setup constraints
    */
    private func setupConstraintsForInput(inputView: UIView, inSectionView sectionView: TASectionWrapperView) {
    
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
        sectionView.layoutIfNeeded()
        sectionView.bottomConstraint = inputView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
    }
    
    
    private func setupConstraintsForFloatingInput(inputView: UIView, inSectionView sectionView: TASectionWrapperView, withMultiplier multiplier: CGFloat, floatPosition: TAFloatPosition) {
        // When formViewBottomConstraints is nil this is the first input to be added. So treatment changes. Either pin top to superview or previous input
        if sectionView.bottomConstraint == nil {
            inputView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
            inputView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
        } else {
            let prevInput = form.orderedFormSubviews.last!
            prevInput.superview!.removeConstraint(sectionView.bottomConstraint)
            
            if floatPosition == TAFloatPosition.First {
                inputView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
                inputView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: prevInput)
            } else {
                inputView.autoPinEdge(ALEdge.Leading, toEdge: ALEdge.Trailing, ofView: prevInput)
                inputView.autoPinEdge(.Top, toEdge: .Top, ofView: prevInput)
            }
        }

        inputView.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: sectionView.superview, withMultiplier: multiplier)
        if floatPosition == TAFloatPosition.Last {
            inputView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
        }
        
        sectionView.bottomConstraint = inputView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
        
        if floatPosition != .First {
            let border = UIView(forAutoLayout: ())
            border.backgroundColor = UIColor ( red: 0.7507, green: 0.7507, blue: 0.7507, alpha: 0.35 )
            inputView.addSubview(border)
            
            border.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Trailing)
            border.autoSetDimension(.Width, toSize: 1)
        }
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
        sectionView.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: sectionView.superview)
        formViewBottomConstraints = sectionView.superview!.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: sectionView)
    }

}