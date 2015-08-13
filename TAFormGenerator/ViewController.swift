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
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.autoSetDimension(ALDimension.Height, toSize: 60)

        formBuilder.addSection(headerView, withID: "Header1")
        
        let headerView2 = UIView()
        headerView2.backgroundColor = UIColor.redColor()
        headerView2.autoSetDimension(ALDimension.Height, toSize: 90)

        formBuilder.addSection(headerView2, withID: "Header2")

        
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "test"), withID: "test", inSectionID: "Header1")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "testtest"), withID: "testtest", inSectionID: "Header1")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "zaza"), withID: "zaza", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "tete"), withID: "tete", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "nbbb"), withID: "nbbb", inSectionID: "Header2")


//        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "zazazazaza"), withID: "test")
//        
//        
//        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeHolder: "dsqdsdsqdsqsddsq"), withID: "test")
//
//        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextEmailField, placeHolder: "email"), withID: "test")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

