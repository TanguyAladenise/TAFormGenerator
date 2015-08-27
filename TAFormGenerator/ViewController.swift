//
//  ViewController.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 12/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class ViewController: TAFormViewController, TAFormViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        formBuilder.addSection(TADefaultFormHeaderView(headerTitle: "test"), withID: "Header1")
        formBuilder.addSection(TADefaultFormHeaderView(headerTitle: "test"), withID: "Header2")
        
        formBuilder.addSection(TADefaultFormHeaderView(headerTitle: "test"), withID: "Header3")

    
        
        formBuilder.addSection(TADefaultFormHeaderView(headerTitle: "test"), withID: "Header5")

        
        formBuilder.addInput(TAInputBuilder.textInputWithStyle(.TextField, placeholder: "text"), withID: "text", inSectionID: "Header1")

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
    
        var validator         = TAInputValidator()
        validator.isMandatory = true
        formValidator.addValidator("Stepper", inputValidator: validator)
        
        
        var validator2 = TAInputValidator()
        validator.isMandatory = true
        formValidator.addValidator("image", inputValidator: validator)
    }
    
    
    func formDidValidate(formViewController: TAFormViewController) {
        println("is valid")
    }
    
    func formDidNotValidate(formViewController: TAFormViewController, error: NSError?) {
        println("is NOT valid")
        println(error)
    }
    
    deinit {
        println("deinit form")
    }
    
    


}

