//
//  TAAddLinkViewController.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 20/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class TALink: NSObject {
    var type: String!
    var url: String!
    
    init(type: String, url: String) {
        self.type = type
        self.url  = url
    }
}


@objc protocol TAAddLinkControllerDelegate: class {
    optional func addLinkController(picker: TAAddLinkViewController, didFinishAddingLink link: TALink)
    optional func addLinkControllerDidCancel(picker: TAAddLinkViewController)
}


class TAAddLinkViewController: UIViewController {

    @IBOutlet weak var formWrapper: UIView!
    private var dropdown: TADropdownInput!
    private var urlInput: TAURLInput!
    
    private var didSetupConstraints: Bool = false
    
    
    weak var delegate: TAAddLinkControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let options = ["Facebook", "Twitter", "Spotify", "Pinterest", "Instagram", "Periscope", "Web"]
        dropdown    = TADropdownOptionsInput(dropdownOptions: options, placeholder: NSLocalizedString("Type", comment: "Type for link type (facebook, twitter, etc"))
        urlInput    = TAURLInput(placeholder: NSLocalizedString("Address", comment: "Address for url address (link)"))
        
        formWrapper.addSubview(dropdown)
        formWrapper.addSubview(urlInput)
        
        let tap = UITapGestureRecognizer(target: self, action: "endEditing")
        view.addGestureRecognizer(tap)
    }

    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            dropdown.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            urlInput.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
            
            dropdown.autoPinEdge(.Bottom, toEdge: .Top, ofView: urlInput)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    
    // MARK: - UI Actions
    
    
    func endEditing() {
        view.endEditing(true)
    }
    
    
    @IBAction func cancelBtnPressed(sender: UIButton) {
        if self.delegate?.addLinkControllerDidCancel?(self) == nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    
    @IBAction func addButtonPressed(sender: UIButton) {
        if let link = getLink() {
            self.delegate?.addLinkController?(self, didFinishAddingLink: link)
        }
    }
    
    
    func getLink() -> TALink? {
        if let type = dropdown.inputValue(), url = urlInput.inputValue() {
            return TALink(type: type, url: url)
        } else {
            return nil
        }
    }

}
