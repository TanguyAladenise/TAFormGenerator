//
//  TALinksInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 20/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class TALinksInput: TATextInput, TAAddLinkControllerDelegate {

    var linksWrapper: UIView = UIView(forAutoLayout: ())
    var linksWrapperBottomConstraint: NSLayoutConstraint!
    
    weak var target: UIViewController?
    
    var linkViews: [UIView] = []
    var links: [TALink] = []
    

    // MARK: - Lifecycle
    
    
    /**
    Init a linksInput with a placeholder and target.
    
    :param: placeholder Placeholder label. Optional.
    :param: target The target to host view controllers event. Required for input to work.
    
    :returns: An instance of LinksInput
    */
    convenience init(placeholder: String? = nil, target: UIViewController) {
        self.init(frame: CGRectZero)
        
        self.textField.placeholder = placeholder
        self.target = target
    }
    
    
    /**
    Default setup for input
    */
    override func setup() {
        super.setup()
        
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        addSubview(linksWrapper)
        
        let imageView           = UIImageView(image: UIImage(named: "icoIncrease"))
        textField.rightView     = imageView
        textField.rightViewMode = UITextFieldViewMode.Always
    }
    
    
    // MARK: - Input protocol
    
    
    override func inputValue() -> AnyObject? {
        let values: [String] = []
        for link in links {
            values.append(link)
        }
    }
    
    
    // MARK: - UI actions
    
    
    /**
    Show the add link modal
    */
    func addLink() {
        let vc      = TAAddLinkViewController(nibName: "AddLinkViewController", bundle: nil)
        vc.delegate = self
        
        // Use target for presenting controller
        if let target = target {
            target.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - View
    
    
    /**
    Insert a new link to the input
    
    :param: link Link to add
    */
    func insertLink(link: TALink) {
        let linkView = generateLinkView(link)
        linksWrapper.insertSubview(linkView, atIndex: 0)
        // Set constraints
        setConstraintsForLinkView(linkView)
        // Store for reuse
        linkViews.append(linkView)
        links.append(link)
        
        // Animate
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    /**
    Create a link view
    
    :param: link Link to set data
    
    :returns: A view representing the link object
    */
    func generateLinkView(link: TALink) -> UIView {
        let wrapper = UIView(forAutoLayout: ())
        
        let imageView           = UIImageView()
        imageView.contentMode   = UIViewContentMode.ScaleAspectFit
        imageView.image         = UIImage(named: "icoAdd")
        wrapper.backgroundColor = UIColor.whiteColor()
        wrapper.addSubview(imageView)
        
        let label           = UILabel(forAutoLayout: ())
        label.textColor     = UIColor.blackColor()
        label.text          = link.url
        label.numberOfLines = 0
        wrapper.addSubview(label)
        
        let border = UIView(forAutoLayout: ())
        border.backgroundColor = UIColor ( red: 0.7507, green: 0.7507, blue: 0.7507, alpha: 0.35 )
        wrapper.addSubview(border)
        
        imageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 5, relation: NSLayoutRelation.GreaterThanOrEqual)
        imageView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5, relation: NSLayoutRelation.GreaterThanOrEqual)
        imageView.autoPinEdgeToSuperviewEdge(.Leading, withInset: 15)
        imageView.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
        imageView.autoSetDimensionsToSize(CGSizeMake(30, 30))
        
        label.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Leading)
        imageView.autoPinEdge(.Trailing, toEdge: .Leading, ofView: label, withOffset: -15)
        
        border.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: border.superview)
        border.autoSetDimension(ALDimension.Height, toSize: 1)
        border.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
        
        layoutIfNeeded()
        return wrapper
    }
    
    
    // MARK: - TextField delegate
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        addLink()
        return false
    }
    
    
    // MARK: - AddLinkControllerDelegate
    
    
    func addLinkControllerDidCancel(picker: TAAddLinkViewController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func addLinkController(picker: TAAddLinkViewController, didFinishAddingLink link: TALink) {
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.insertLink(link)
        })
    }
    
    
    // MARK: - Layout
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            super.updateConstraints()

            textField.superview!.removeConstraint(textFieldTopConstraint)
            linksWrapper.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
            linksWrapper.autoPinEdge(.Bottom, toEdge: .Top, ofView: textField)
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    
    func setConstraintsForLinkView(view: UIView) {
        // Two steps layout for animation
        var topConstraint: NSLayoutConstraint?
        
        if linksWrapperBottomConstraint == nil {
        } else {
            let prevView = linkViews.last!
            prevView.superview!.removeConstraint(linksWrapperBottomConstraint)
            topConstraint = view.autoPinEdge(.Top, toEdge: .Top, ofView: prevView)
        }
        
        view.autoPinEdgeToSuperviewEdge(.Leading)
        view.autoPinEdgeToSuperviewEdge(.Trailing)
        linksWrapperBottomConstraint = view.autoPinEdgeToSuperviewEdge(.Bottom)

        layoutIfNeeded()
        
        // Two steps layout for animation
        if linkViews.count == 0 {
            view.autoPinEdge(.Top, toEdge: .Top, ofView: view.superview!)
        } else {
            let prevView = linkViews.last!
            view.superview!.removeConstraint(topConstraint!)
            view.autoPinEdge(.Top, toEdge: .Bottom, ofView: prevView)
        }

    }

}
