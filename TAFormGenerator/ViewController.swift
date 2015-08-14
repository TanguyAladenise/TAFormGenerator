//
//  ViewController.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 12/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.greenColor()
        headerView.autoSetDimension(ALDimension.Height, toSize: 60)

        formBuilder.addSection(headerView, withID: "Header1")
        
        let headerView2 = UIView()
        headerView2.backgroundColor = UIColor.greenColor()
        headerView2.autoSetDimension(ALDimension.Height, toSize: 60)

        formBuilder.addSection(headerView2, withID: "Header2")
        
        let headerView3 = UIView()
        headerView3.backgroundColor = UIColor.greenColor()
        headerView3.autoSetDimension(ALDimension.Height, toSize: 60)
        formBuilder.addSection(headerView3, withID: "Header3")


        
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "text"), withID: "text", inSectionID: "Header1")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextTwitterField, placeHolder: "twitter"), withID: "testtest", inSectionID: "Header1")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextEmailField, placeHolder: "email"), withID: "zaza", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextPhoneField, placeHolder: "phone"), withID: "tete", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextSecure, placeHolder: "password"), withID: "nbbb", inSectionID: "Header2")
        
        formBuilder.addInput(InputBuilder.textInputWithStyle(.NumberField, placeHolder: "number"), withID: "vdx", inSectionID: "Header2")

        
        
        var inputs = [InputBuilder.textInputWithStyle(.TextField, placeHolder: "first"), InputBuilder.textInputWithStyle(.TextField, placeHolder: "second")]
        
        var ids = ["1", "2"]

        formBuilder.addFloatingInputs(inputs, withMatchingIDs: ids, inSectionID: "Header3", atPositions: 0.75, 1)
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "testtestzadazda"), withID: "145", inSectionID: "Header3")
        formBuilder.addInput(InputBuilder.radioButtons("Size", options: ["XS", "S", "M", "L", "XL"]), withID: "radio", inSectionID: "Header3")
        formBuilder.addInput(InputBuilder.radioButtons("Gender", options: ["Male", "Female"]), withID: "gender", inSectionID: "Header3")
        formBuilder.addInput(InputBuilder.radioButtons("DO YOU WISH TO BLAH BLAH THIS IS TWO LINES QUESTION THAT TAKES MORE SPACE", options: ["YES", "NO"]), withID: "question1", inSectionID: "Header3")
        
        formBuilder.addInput(InputBuilder.dropdownInput(placeholder: "Dropdown"), withID: "Dropdown", inSectionID: "Header3")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

