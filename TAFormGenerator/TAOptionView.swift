//
//  TAOptionView.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 14/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class TAOptionView: UIView {
    
    let normalBackgroundColor   = UIColor ( red: 0.9719, green: 0.972, blue: 0.972, alpha: 1.0 )
    let selectedBackgroundColor = UIColor.blackColor()
    
    let normalTextColor   = UIColor ( red: 0.5407, green: 0.5407, blue: 0.5407, alpha: 1.0 )
    let selectedTextColor = UIColor.whiteColor()

    private var didSetupConstraints = false
    
    var selected = false
    
    
    private var label: UILabel = UILabel()
    
    
    var optionLabel: String! {
        didSet{
            label.text = optionLabel
        }
    }
    
    
    // MARK: - Lifecycle
    
    
    convenience init(optionLabel: String?, selected: Bool? = false) {
        self.init(frame: CGRectZero)
        
        self.optionLabel = optionLabel
        self.label.text  = optionLabel
        self.setSelected(selected!, animated: false)
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
        
        clipsToBounds = true
        
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(13)
        setSelected(selected, animated: false)
    }
    
    
    // MARK: - Selection
    
    
    func setSelected(selected: Bool, animated: Bool) {
        self.selected = selected
        
        let newBGColor   = (selected) ? selectedBackgroundColor : normalBackgroundColor
        let newTextColor = (selected) ? selectedTextColor : normalTextColor
        
        if animated {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.backgroundColor = newBGColor
                self.label.textColor = newTextColor
            }, completion: nil)
        } else {
            self.backgroundColor = newBGColor
            self.label.textColor = newTextColor
        }
    }
    
    
    // MARK: - Layout
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            autoSetDimension(ALDimension.Height, toSize: 35)
            autoSetDimension(.Width, toSize: 35, relation: NSLayoutRelation.GreaterThanOrEqual)

            label.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 10, 0, 10))
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = CGRectGetHeight(frame) / 2
    }
}
