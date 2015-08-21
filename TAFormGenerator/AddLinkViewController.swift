//
//  AddLinkViewController.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 20/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class Link: NSObject {
    var type: String!
    var url: String!
    
    init(type: String, url: String) {
        self.type = type
        self.url  = url
    }
}


@objc protocol AddLinkControllerDelegate: class {
    optional func addLinkController(picker: AddLinkViewController, didFinishAddingLink link: Link)
    optional func addLinkControllerDidCancel(picker: AddLinkViewController)
}


class AddLinkViewController: UIViewController {

    @IBOutlet weak var formWrapper: UIView!
    private var dropdown: DropdownInput!
    private var urlInput: URLInput!
    
    private var didSetupConstraints: Bool = false
    
    
    weak var delegate: AddLinkControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let options = ["Facebook", "Twitter", "Spotify", "Pinterest", "Instagram", "Periscope", "Web"]
        dropdown    = DropdownOptionsInput(dropdownOptions: options, placeholder: NSLocalizedString("Type", comment: "Type for link type (facebook, twitter, etc"))
        urlInput    = URLInput(placeholder: NSLocalizedString("Address", comment: "Address for url address (link)"))
        
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
    
    
    func getLink() -> Link? {
        if let type = dropdown.inputValue(), url = urlInput.inputValue() {
            return Link(type: type, url: url)
        } else {
            return nil
        }
    }

}
