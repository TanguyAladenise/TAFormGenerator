//
//  TAStepperInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 25/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class TAStepperInput: UIView {

    // UI
    private let label: UILabel! = UILabel()
    private let increaseBtn = UIButton.buttonWithType(.Custom) as! UIButton
    private let decreaseBtn = UIButton.buttonWithType(.Custom) as! UIButton
    private let border: UIView  = UIView()
    
    // Constraints
    private var didSetupConstraints: Bool = false
    
    
    var placeholder: String?
    
    private var value: Int = 0
    private var step: Int = 1
    
    private var minValue: Int?
    private var maxValue: Int?
    
    
    private var timer: NSTimer?
    private var startTimerDate: NSDate?
    
    
    // MARK: - Lifecycle
    
    
    convenience init(placeholder: String?) {
        self.init(frame: CGRectZero)
        
        self.placeholder = placeholder?.uppercaseString
        label.text = self.placeholder
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        setup()
    }
    
    
    func setup() {
        
        minValue = 0
        
        backgroundColor = UIColor.whiteColor()

        addSubview(label)
        label.font            = UIFont.systemFontOfSize(14)
        label.textColor       = UIColor ( red: 0.5407, green: 0.5407, blue: 0.5407, alpha: 0.62 )
        label.backgroundColor = UIColor.clearColor()
        
        addSubview(decreaseBtn)
        decreaseBtn.setImage(UIImage(named: "icoDecrease"), forState: .Normal)
        decreaseBtn.addTarget(self, action: "stepperPressed:", forControlEvents: .TouchUpInside)
        
        addSubview(increaseBtn)
        increaseBtn.setImage(UIImage(named: "icoIncrease"), forState: .Normal)
        increaseBtn.addTarget(self, action: "stepperPressed:", forControlEvents: .TouchUpInside)
        
        border.backgroundColor = UIColor ( red: 0.7507, green: 0.7507, blue: 0.7507, alpha: 0.35 )
        addSubview(border)
        
        var longPressureDecrease = UILongPressGestureRecognizer(target: self, action: "longPress:")
        longPressureDecrease.minimumPressDuration = 0.2
        decreaseBtn.addGestureRecognizer(longPressureDecrease)
        
        var longPressureIncrease = UILongPressGestureRecognizer(target: self, action: "longPress:")
        longPressureIncrease.minimumPressDuration = 0.2
        increaseBtn.addGestureRecognizer(longPressureIncrease)
    }

    
    // MARK: - UI Control
    
    
    func stepperPressed(sender: UIButton) {
        if sender == decreaseBtn {
            decreaseStepper()
        } else {
            increaseStepper()
        }
    }
    
    
    func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .Began {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: "timerUpdate:", userInfo: ["view" : gesture.view!], repeats: false)
            startTimerDate = NSDate()
        } else if gesture.state == .Cancelled || gesture.state == .Ended || gesture.state == .Failed {
            timer!.invalidate()
            timer = nil
        }
    }
    
    
    // MARK: - Timer
    
    
    func timerUpdate(timer: NSTimer) {
        if let userInfo = timer.userInfo as? [String : UIView] {
            if let view = userInfo["view"] {
                if view == decreaseBtn {
                    decreaseStepper()
                } else {
                    increaseStepper()
                }
                
                let totalTime = Int(NSDate().timeIntervalSinceDate(startTimerDate!))
                var timeInterval = 0.15
                if totalTime > 2 && totalTime <= 6 {
                    timeInterval = 0.1
                } else if totalTime > 6 && totalTime <= 12 {
                    timeInterval = 0.05
                } else if totalTime > 12 {
                    timeInterval = 0.01
                }
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "timerUpdate:", userInfo: ["view" : view], repeats: false)
            }
        }
    }
    
    
    // MARK: - Stepper mechanic
    
    
    func decreaseStepper() {
        if label.text == placeholder {
            if let min = minValue {
                label.text = "\(min)"
                value = min
            } else {
                label.text = "\(self.value)"
            }
        } else {
            value -= step
            if let min = minValue {
                value = max(value, min)
            }
            
            label.text = "\(value)"
        }
    }
    
    
    func increaseStepper() {
        if label.text == placeholder {
            if let max = maxValue {
                label.text = "\(max)"
                value = max
            } else {
                label.text = "\(value)"
            }
        } else {
            value += step
            if let max = maxValue {
                value = min(value, max)
            }
            label.text = "\(value)"
        }
    }
    
    
    // MARK: - Layout
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            decreaseBtn.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 15, 0, 0), excludingEdge: .Trailing)
            increaseBtn.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 15), excludingEdge: .Leading)
            
            label.autoCenterInSuperview()

            border.autoSetDimension(ALDimension.Height, toSize: 1)
            border.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
            
            didSetupConstraints = true
        }
        
        
        super.updateConstraints()
    }

}
