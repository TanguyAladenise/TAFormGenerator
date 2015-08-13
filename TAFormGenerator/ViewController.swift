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


        
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "test"), withID: "test", inSectionID: "Header1")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "testtest"), withID: "testtest", inSectionID: "Header1")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "zaza"), withID: "zaza", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "tete"), withID: "tete", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "nbbb"), withID: "nbbb", inSectionID: "Header2")
        
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "zaza"), withID: "vdx", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "tete"), withID: "gr", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "nbbb"), withID: "za", inSectionID: "Header2")
        
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "zaza"), withID: "hyt", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "tete"), withID: "zds", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "nbbb"), withID: "nbhtygfbb", inSectionID: "Header2")
        
        
        var inputs = [InputBuilder.textInputWithStyle(.TextField, placeHolder: "first"), InputBuilder.textInputWithStyle(.TextField, placeHolder: "second")]
        
        var ids = ["1", "2"]

        formBuilder.addFloatingInputs(inputs, withMatchingIDs: ids, inSectionID: "Header3", atPositions: 0.75, 1)
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "testtestzadazda"), withID: "145", inSectionID: "Header3")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

