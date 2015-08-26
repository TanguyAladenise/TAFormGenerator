//
//  TARadioButtonsInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 14/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit


class TARadioButtonsInput: UIView, TAInputProtocol {
    
    private var optionViews: [UIView] = []
    private var selectedOptionView: TAOptionView!
    
    private var optionsWrapper: UIView = UIView()
    private var label: UILabel         = UILabel()
    private var border: UIView         = UIView()

    // Layout
    var didSetupConstraints: Bool = false
    var wrapperTrailingConstraint: NSLayoutConstraint!
    
    
    // MARK: - Lifecycle
    
    
    /**
    Init a radio input with its label and different options
    
    :param: label   The label for the input. Display on the left
    :param: options The options selectable by the input
    
    :returns: The input view
    */
    convenience init(label: String, options: [String]?) {
        self.init(frame: CGRectZero)
        
        self.label.text = label
        
        if let opts = options {
            for option in opts {
                addOption(option)
            }
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        setup()
    }
    
    
    /**
    Default setup for input
    */
    func setup() {
        backgroundColor = UIColor.whiteColor()

        addSubview(label)
        label.numberOfLines = 0
        label.font          = UIFont.systemFontOfSize(12)
        label.textColor     = UIColor ( red: 0.5407, green: 0.5407, blue: 0.5407, alpha: 0.62 )

        addSubview(optionsWrapper)
        
        addSubview(border)
        border.backgroundColor = UIColor ( red: 0.7507, green: 0.7507, blue: 0.7507, alpha: 0.35 )
        
        setTranslatesAutoresizingMaskIntoConstraints(false)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        optionsWrapper.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    
    // MARK: - Input protocol
    
    
    func inputValue() -> AnyObject? {
        return selectedOptionView.value
    }
    
    // MARK: - Option setup
    
    
    /**
    Add an option to the input
    
    :param: option Option label
    */
    func addOption(option: String) {
        // Create the view
        let option = TAOptionView(optionLabel: option)
        option.setTranslatesAutoresizingMaskIntoConstraints(false)
        optionsWrapper.addSubview(option)
        
        // Constraints
        setupConstraintsForOption(option)
        
        // Bind touch events
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        option.addGestureRecognizer(tap)
        
        // Store for reuse (useful for constraints setup
        optionViews.append(option)
        
        // By default the first option will be selected
        if selectedOptionView == nil {
            selectedOptionView = option
            option.setSelected(true, animated: false)
        }
    }
    
    
    // MARK: - UI Actions
    
    
    func handleTap(gesture: UITapGestureRecognizer) {
        if let optionView = gesture.view as? TAOptionView {
            
            // Ignore tap on already selected option
            if optionView == selectedOptionView {
                return
            }
            
            // Change selected focus
            selectedOptionView.setSelected(false, animated: true)
            optionView.setSelected(true, animated: true)
            selectedOptionView = optionView
        }
    }
    
    
    // MARK: - Layout
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            // Set default constraints for view to work (label floating left, options floating right and border at the bottom)
            
            autoSetDimension(ALDimension.Height, toSize: 50, relation: NSLayoutRelation.GreaterThanOrEqual)
            
            label.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 15, 0, 0), excludingEdge: ALEdge.Trailing)
            
            optionsWrapper.autoPinEdge(.Leading, toEdge: .Trailing, ofView: label, withOffset: 0, relation: NSLayoutRelation.GreaterThanOrEqual)
            optionsWrapper.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Leading)
            optionsWrapper.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: self, withMultiplier: 0.4, relation: NSLayoutRelation.GreaterThanOrEqual)
            optionsWrapper.autoMatchDimension(ALDimension.Height, toDimension: ALDimension.Height, ofView: label)
            
            border.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: border.superview)
            border.autoSetDimension(ALDimension.Height, toSize: 1)
            border.autoAlignAxisToSuperviewAxis(ALAxis.Vertical)
            border.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.preferredMaxLayoutWidth = CGRectGetWidth(label.frame)
    }
    
    
    /**
    Setup constraints for dynamic new view
    
    :param: optionView Optiokn view added
    */
    func setupConstraintsForOption(optionView: UIView) {
        
        // If first option left side stick to superview, otherwise it sticks to previous option view
        if optionViews.count == 0 {
            optionView.autoPinEdge(.Trailing, toEdge: .Left, ofView: optionView.superview, withOffset: 15, relation: NSLayoutRelation.GreaterThanOrEqual)
        } else {
            let prevInput = optionViews.last
            prevInput!.superview!.removeConstraint(wrapperTrailingConstraint)
            optionView.autoPinEdge(ALEdge.Leading, toEdge: ALEdge.Trailing, ofView: prevInput, withOffset: 12)
        }
        
        optionView.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
        wrapperTrailingConstraint = optionView.autoPinEdge(ALEdge.Trailing, toEdge: ALEdge.Right, ofView: self.optionsWrapper, withOffset: -15)
    }

}
