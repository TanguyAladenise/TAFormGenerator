//
//  TATextViewInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 27/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class TATextViewInput: UIView, TAInputProtocol, UITextViewDelegate {

    private let textView: UITextView! = UITextView(forAutoLayout: ())
    private var border: UIView  = UIView(forAutoLayout: ())
    
    private var didSetupConstraints: Bool = false
    
    var placeholder: String?
    
    
    // MARK: - Lifecycle
    
    
    convenience init(placeholder: String?) {
        self.init(frame: CGRectZero)
        
        self.placeholder = placeholder?.uppercaseString
        
        checkPlaceholder()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        setup()
    }
    
    
    func setup() {
        addSubview(textView)
        textView.font          = UIFont.systemFontOfSize(14)
        textView.scrollEnabled = false
        textView.delegate      = self
        
        backgroundColor = UIColor.whiteColor()

        border.backgroundColor = UIColor ( red: 0.7507, green: 0.7507, blue: 0.7507, alpha: 0.35 )
        addSubview(border)
        
        checkPlaceholder()
    }
    
    
    func checkPlaceholder() {
        if count(textView.text) == 0 {
            textView.text      = placeholder
            textView.textColor = UIColor ( red: 0.5407, green: 0.5407, blue: 0.5407, alpha: 0.62 )
        }
    }
    
    
    // MARK: - Protocol
    
    
    func inputValue() -> AnyObject? {
        if textView.text == "" || textView.text == placeholder {
            return nil
        } else {
            return textView.text
        }
    }
    
    
    // MARK: - UITextView delegate
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        checkPlaceholder()
    }
       
    
    
    // MARK: - Layout
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            autoSetDimension(.Height, toSize: 50, relation: NSLayoutRelation.GreaterThanOrEqual)
            textView.autoSetDimension(.Height, toSize: 20, relation: NSLayoutRelation.GreaterThanOrEqual)
            
            textView.autoPinEdgeToSuperviewEdge(.Top, withInset: 10, relation: NSLayoutRelation.GreaterThanOrEqual)
            textView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10, relation: NSLayoutRelation.GreaterThanOrEqual)
            textView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            textView.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            
            border.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: border.superview)
            border.autoSetDimension(ALDimension.Height, toSize: 1)
            border.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    

}
