//
//  LinksInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 20/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class LinksInput: TextInput, AddLinkControllerDelegate {

    var linksWrapper: UIView = UIView(forAutoLayout: ())
    var linksWrapperBottomConstraint: NSLayoutConstraint!
    
    weak var target: UIViewController?
    
    var linkViews: [UIView] = []
    

    // MARK: - Lifecycle
    
    
    convenience init(placeholder: String? = nil, target: UIViewController) {
        self.init(frame: CGRectZero)
        
        self.textField.placeholder = placeholder
        self.target = target
    }
    
    
    override func setup() {
        super.setup()
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.addSubview(linksWrapper)
        
        let imageView                = UIImageView(image: UIImage(named: "icoAdd"))
        self.textField.rightView     = imageView
        self.textField.rightViewMode = UITextFieldViewMode.Always
    }
    
    
    // MARK: - UI actions
    
    
    func addLink() {
        let vc      = AddLinkViewController(nibName: "AddLinkViewController", bundle: nil)
        vc.delegate = self
        if let target = target {
            target.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - View
    
    
    func insertLink(link: Link) {
        let linkView = generateLinkView(link)
        linksWrapper.insertSubview(linkView, atIndex: 0)
        setConstraintsForLinkView(linkView)
        linkViews.append(linkView)
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func generateLinkView(link: Link) -> UIView {
        let wrapper = UIView(forAutoLayout: ())
        
        let imageView           = UIImageView()
        imageView.contentMode   = UIViewContentMode.ScaleAspectFit
        imageView.image         = UIImage(named: "greenCheck")
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
    
    
    func addLinkControllerDidCancel(picker: AddLinkViewController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func addLinkController(picker: AddLinkViewController, didFinishAddingLink link: Link) {
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
