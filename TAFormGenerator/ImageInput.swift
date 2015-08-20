//
//  ImageInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 20/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

class ImageInput: UIView, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UI
    private let label: UILabel!                 = UILabel(forAutoLayout: ())
    private let border: UIView                  = UIView(forAutoLayout: ())
    private let actionBtn: UIButton             = UIButton.buttonWithType(.Custom) as! UIButton
    private let imageView: UIImageView          = UIImageView(forAutoLayout: ())
    private let loader: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    private var didSetupConstraints: Bool = false
    weak var target: UIViewController?


    // MARK: - Lifecycle
    
    
    convenience init(label: String, target: UIViewController) {
        self.init(frame: CGRectZero)
        
        self.label.text = label
        self.target = target
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        setup()
    }
    
    
    private func setup() {
        self.addSubview(self.label)
        self.label.backgroundColor = UIColor.clearColor()
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.actionBtn.setImage(UIImage(named: "icoAdd"), forState: .Normal)
        self.actionBtn.setImage(UIImage(named: "greenCheck"), forState: .Selected)
        self.actionBtn.addTarget(self, action: "actionBtnPressed:", forControlEvents: .TouchUpInside)
        self.addSubview(self.actionBtn)
        
        self.addSubview(self.loader)

        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(self.imageView)
        
        self.border.backgroundColor = UIColor ( red: 0.7507, green: 0.7507, blue: 0.7507, alpha: 0.35 )
        self.addSubview(self.border)
    }
    
    
    // MARK: - UI Actions
    
    
    func actionBtnPressed(sender: UIButton) {
        if sender.selected {
            setImage(nil)
        } else {
            loader.startAnimating()
            actionBtn.hidden = true
            
            let actionSheet       = UIActionSheet(title: nil, delegate: nil, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), destructiveButtonTitle: nil)
            var actions: [String] = [NSLocalizedString("Take a photo", comment: ""), NSLocalizedString("Choose a picture", comment: "")]
            for action in actions {
                actionSheet.addButtonWithTitle(action)
            }
            actionSheet.actionSheetStyle = .Default
            actionSheet.delegate         = self
            actionSheet.showInView(self)
        }
    }
    
    
    func setImage(image: UIImage?) {
        imageView.image = image
        
        if let img = image {
            imageView.alpha = 0
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.imageView.alpha = 1
            }) { (completed: Bool) -> Void in
                self.loader.stopAnimating()
                self.actionBtn.selected = true
                self.actionBtn.hidden   = false
            }
        } else {
            loader.stopAnimating()
            actionBtn.hidden   = false
            actionBtn.selected = false
        }
        
    }
    
    // MARK: - Action sheet delegate
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        var imagePicker      = UIImagePickerController()
        imagePicker.delegate = self
        switch buttonIndex {
        case 2:
            imagePicker.sourceType = .PhotoLibrary
        case 1:
            imagePicker.sourceType = .Camera
        case 0: // Cancel
            setImage(nil)
            return
        default:
            imagePicker.sourceType = .PhotoLibrary
        }
        
        if let target = target {
            target.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - UIImagePicker delegate
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.setImage(image)
        })
    }

    
    // MARK: - Layout
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            label.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 15, 0, 0), excludingEdge: .Trailing)
            actionBtn.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Leading)
            actionBtn.autoSetDimension(.Width, toSize: 50)
            
            loader.autoAlignAxis(ALAxis.Horizontal, toSameAxisOfView: actionBtn)
            loader.autoPinEdge(.Leading, toEdge: .Leading, ofView: actionBtn)
            loader.autoMatchDimension(.Width, toDimension: .Width, ofView: actionBtn)
            
            imageView.autoPinEdge(.Trailing, toEdge: .Leading, ofView: actionBtn)
            imageView.autoAlignAxis(.Horizontal, toSameAxisOfView: imageView.superview!)
            imageView.autoMatchDimension(.Width, toDimension: .Width, ofView: imageView.superview!, withMultiplier: 0.3)
            imageView.autoSetDimension(ALDimension.Height, toSize: 70)
            imageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 2)
            imageView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 2)
            
            border.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: border.superview)
            border.autoSetDimension(ALDimension.Height, toSize: 1)
            border.autoAlignAxisToSuperviewAxis(ALAxis.Vertical)
            border.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
}
