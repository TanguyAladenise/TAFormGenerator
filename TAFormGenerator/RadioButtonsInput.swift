//
//  RadioButtonsInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 14/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit


class RadioButtonsInput: UIView {
    
    private var optionViews: [UIView] = []
    private var selectedOptionView: OptionView!
    
    private var optionsWrapper: UIView = UIView()
    private var label: UILabel         = UILabel()
    private var border: UIView         = UIView()

    // Layout
    var didSetupConstraints: Bool = false
    var wrapperTrailingConstraint: NSLayoutConstraint!
    
    
    // MARK: - Lifecycle
    
    
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
    
    
    func setup() {
        addSubview(label)
        addSubview(optionsWrapper)
        addSubview(border)
        
        backgroundColor = UIColor.whiteColor()
        
        label.numberOfLines = 0
        
        setTranslatesAutoresizingMaskIntoConstraints(false)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        optionsWrapper.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    
    // MARK: - Option setup
    
    
    func addOption(option: String) {
        let option = OptionView(optionLabel: option)
        option.setTranslatesAutoresizingMaskIntoConstraints(false)
        optionsWrapper.addSubview(option)
        
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        option.addGestureRecognizer(tap)
        
        setupConstraintsForOption(option)
        optionViews.append(option)
        
        if selectedOptionView == nil {
            selectedOptionView = option
            option.setSelected(true, animated: false)
        }
    }
    
    
    
    func handleTap(gesture: UITapGestureRecognizer) {
        if let optionView = gesture.view as? OptionView {
            
            if optionView == selectedOptionView {
                return
            }
            
            selectedOptionView.setSelected(false, animated: true)
            optionView.setSelected(true, animated: true)
            selectedOptionView = optionView
        }
    }
    
    
    // MARK: - Layout
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
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
    
    
    func setupConstraintsForOption(optionView: UIView) {
        if optionViews.count == 0 {
            optionView.autoPinEdge(.Trailing, toEdge: .Left, ofView: optionView.superview, withOffset: 15, relation: NSLayoutRelation.GreaterThanOrEqual)
        } else {
            let prevInput = optionViews.last
            prevInput!.superview!.removeConstraint(wrapperTrailingConstraint)
            optionView.autoPinEdge(ALEdge.Leading, toEdge: ALEdge.Trailing, ofView: prevInput, withOffset: 12)
//            optionView.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: prevInput)
        }
        
        optionView.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
        wrapperTrailingConstraint = optionView.autoPinEdge(ALEdge.Trailing, toEdge: ALEdge.Right, ofView: self.optionsWrapper, withOffset: -15)
    }

}
