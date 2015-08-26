//
//  TADefaultFormHeaderView.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 24/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class TADefaultFormHeaderView: UIView {

    private var border: UIView = UIView()
    private var label: UILabel = UILabel()
    
    private var didSetupConstraints: Bool = false
    
    
    var title: String? {
        didSet{
            label.text = title?.uppercaseString
        }
    }
    
    
    // MARK: - Lifecycle
    
    
    convenience init(headerTitle: String?) {
        self.init(frame: CGRectZero)
        
        self.title = headerTitle
        label.text = title?.uppercaseString
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
        label.textAlignment = NSTextAlignment.Center
        label.font          = UIFont.systemFontOfSize(15)
        label.numberOfLines = 0
        
        backgroundColor = UIColor ( red: 0.9719, green: 0.972, blue: 0.972, alpha: 1.0 )
        
        border.backgroundColor = UIColor ( red: 0.7507, green: 0.7507, blue: 0.7507, alpha: 0.35 )
        addSubview(border)
    }
    
    
    // MARK: - Constraints
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            label.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(15, 15, 15, 15))
            
            autoSetDimension(.Height, toSize: 50, relation: NSLayoutRelation.GreaterThanOrEqual)
            
            border.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: border.superview!)
            border.autoSetDimension(ALDimension.Height, toSize: 1)
            border.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }

}
