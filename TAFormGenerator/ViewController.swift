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

        
        let headerView4 = UIView()
        headerView4.backgroundColor = UIColor.greenColor()
        headerView4.autoSetDimension(ALDimension.Height, toSize: 60)
        let btn = UIButton()
        btn.setTitle("Add", forState: .Normal)
        btn.addTarget(self, action: "add:", forControlEvents: .TouchUpInside)
        headerView4.addSubview(btn)
        btn.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
        btn.autoAlignAxisToSuperviewAxis(.Vertical)
        formBuilder.addSection(headerView4, withID: "Header4")
        
        
        let headerView5 = UIView()
        headerView5.backgroundColor = UIColor.grayColor()
        headerView5.autoSetDimension(ALDimension.Height, toSize: 60)
        formBuilder.addSection(headerView5, withID: "Header5")

        
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeholder: "text"), withID: "text", inSectionID: "Header1")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextTwitterField, placeholder: "twitter"), withID: "twitter", inSectionID: "Header1")
        
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextEmailField, placeholder: "email"), withID: "email", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextPhoneField, placeholder: "phone"), withID: "phone", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextSecure, placeholder: "password"), withID: "password", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.NumberField, placeholder: "number"), withID: "number", inSectionID: "Header2")
        formBuilder.addInput(InputBuilder.dropdownInput(["test1", "test2", "test3", "test4"], placeholder: "Dropdown"), withID: "Dropdown", inSectionID: "Header2")

        
       
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeholder: "address"), withID: "address", inSectionID: "Header3")
        var inputs = [InputBuilder.textInputWithStyle(.TextField, placeholder: "country"), InputBuilder.dropdownInput(["zaza", "test", "dw", "cx", "sd", "dsqd"], placeholder: "Year")]
        var ids = ["1", "2"]
        formBuilder.addFloatingInputs(inputs, withMatchingIDs: ids, inSectionID: "Header3", atPositions: 0.5, 1)
        formBuilder.addInput(InputBuilder.radioButtons("Size", options: ["XS", "S", "M", "L", "XL"]), withID: "radio", inSectionID: "Header3")
        formBuilder.addInput(InputBuilder.radioButtons("Gender", options: ["Male", "Female"]), withID: "gender", inSectionID: "Header3")
        formBuilder.addInput(InputBuilder.radioButtons("DO YOU WISH TO BLAH BLAH THIS IS TWO LINES QUESTION THAT TAKES MORE SPACE", options: ["YES", "NO"]), withID: "question1", inSectionID: "Header3")
        
        
        formBuilder.addInput(InputBuilder.imageInput("Image", target: self), withID: "image", inSectionID: "Header5")
        formBuilder.addInput(InputBuilder.linksInput("Add a link", target: self), withID: "links", inSectionID: "Header5")
    
    }
    
    deinit {
        println("deinit form")
    }
    
    
    func add(sender: UIButton) {
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextField, placeholder: "text"), withID: "cwx\(sender.tag)", inSectionID: "Header4")
        formBuilder.addInput(InputBuilder.textInputWithStyle(.TextTwitterField, placeholder: "twitter"), withID: "cxwcwcxwc\(sender.tag)", inSectionID: "Header4")
        sender.tag++
        
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

