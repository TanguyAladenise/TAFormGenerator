//
//  ViewController.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 12/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class ViewController: TAFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        formBuilder.addSection(TADefaultFormHeaderView(headerTitle: "test"), withID: "Header1")
        formBuilder.addSection(TADefaultFormHeaderView(headerTitle: "test"), withID: "Header2")
        
        formBuilder.addSection(TADefaultFormHeaderView(headerTitle: "test"), withID: "Header3")

        
        let headerView4 = UIView()
        headerView4.backgroundColor = UIColor ( red: 0.9719, green: 0.972, blue: 0.972, alpha: 1.0 )
        headerView4.autoSetDimension(ALDimension.Height, toSize: 60)
        let btn = UIButton()
        btn.setTitle("Add", forState: .Normal)
        btn.addTarget(self, action: "add:", forControlEvents: .TouchUpInside)
        headerView4.addSubview(btn)
        btn.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
        btn.autoAlignAxisToSuperviewAxis(.Vertical)
        formBuilder.addSection(headerView4, withID: "Header4")
        
        
        formBuilder.addSection(TADefaultFormHeaderView(headerTitle: "test"), withID: "Header5")

        
        formBuilder.addInput(TAInputBuilder.textInputWithStyle(.TextField, placeholder: "text"), withID: "text", inSectionID: "Header1")
        formBuilder.addInput(TAInputBuilder.textInputWithStyle(.TextTwitterField, placeholder: "twitter"), withID: "twitter", inSectionID: "Header1")

        formBuilder.addInput(TAInputBuilder.textInputWithStyle(.TextEmailField, placeholder: "email"), withID: "email", inSectionID: "Header2")
        formBuilder.addInput(TAInputBuilder.textInputWithStyle(.TextPhoneField, placeholder: "phone"), withID: "phone", inSectionID: "Header2")
        formBuilder.addInput(TAInputBuilder.textInputWithStyle(.TextSecure, placeholder: "password"), withID: "password", inSectionID: "Header2")
        formBuilder.addInput(TAInputBuilder.textInputWithStyle(.NumberField, placeholder: "number"), withID: "number", inSectionID: "Header2")
        formBuilder.addInput(TAInputBuilder.dropdownInput(["test1", "test2", "test3", "test4"], placeholder: "Dropdown"), withID: "Dropdown", inSectionID: "Header2")

       
      
        formBuilder.addInput(TAInputBuilder.textInputWithStyle(.TextField, placeholder: "address"), withID: "address", inSectionID: "Header3")
        var inputs = [TAInputBuilder.textInputWithStyle(.TextField, placeholder: "country"), TAInputBuilder.dropdownInput(["zaza", "test", "dw", "cx", "sd", "dsqd"], placeholder: "Year")]
        var ids = ["1", "2"]
        formBuilder.addFloatingInputs(inputs, withMatchingIDs: ids, inSectionID: "Header3", atPositions: 0.5, 1)
        formBuilder.addInput(TAInputBuilder.radioButtons("Size", options: ["XS", "S", "M", "L", "XL"]), withID: "radio", inSectionID: "Header3")
        formBuilder.addInput(TAInputBuilder.radioButtons("Gender", options: ["Male", "Female"]), withID: "gender", inSectionID: "Header3")
        formBuilder.addInput(TAInputBuilder.radioButtons("DO YOU WISH TO BLAH BLAH THIS IS TWO LINES QUESTION THAT TAKES MORE SPACE", options: ["YES", "NO"]), withID: "question1", inSectionID: "Header3")

        
        formBuilder.addInput(TAInputBuilder.imageInput("Image", target: self), withID: "image", inSectionID: "Header5")
        formBuilder.addInput(TAInputBuilder.linksInput("Add a link", target: self), withID: "links", inSectionID: "Header5")
        formBuilder.addInput(TAInputBuilder.dateInput(UIDatePickerMode.Date, placeholder: "Date"), withID: "Date", inSectionID: "Header5")
        formBuilder.addInput(TAInputBuilder.dateInput(UIDatePickerMode.DateAndTime, placeholder: "DateAndTime"), withID: "DateAndTime", inSectionID: "Header5")
        
        formBuilder.addInput(TAInputBuilder.stepperInput("Stepper"), withID: "Stepper", inSectionID: "Header5")

    }
    
    deinit {
        println("deinit form")
    }
    
    
    func add(sender: UIButton) {
        formBuilder.addInput(TAInputBuilder.textInputWithStyle(.TextField, placeholder: "text"), withID: "cwx\(sender.tag)", inSectionID: "Header4")
        formBuilder.addInput(TAInputBuilder.textInputWithStyle(.TextTwitterField, placeholder: "twitter"), withID: "cxwcwcxwc\(sender.tag)", inSectionID: "Header4")
        sender.tag++
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

}

