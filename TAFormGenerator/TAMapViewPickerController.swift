//
//  TAMapViewPickerController.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 27/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

@objc protocol TAMapViewPickerControllerDelegate: class {
    optional func mapViewPickerController(picker: TAMapViewPickerController, didFinishPickerLocation location: CLLocation?)
    optional func mapViewPickerControllerDidCancel(picker: TAMapViewPickerController)
}

class TAMapViewPickerController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var textFieldWrapper: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapPin: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var textFieldWrapperTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBarHeightConstraint: NSLayoutConstraint!
    
    
    var location: CLLocation?
    
    var text: String! {
        didSet{
            UIView.transitionWithView(self.textField, duration: 0.25, options: UIViewAnimationOptions.CurveEaseInOut | UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.textField.text = self.text
            }, completion: nil)
        }
    }
    
    
    weak var delegate: TAMapViewPickerControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource      = self
        tableView.delegate        = self
        mapView.delegate          = self
        textField.delegate        = self
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField.rightViewMode   = UITextFieldViewMode.UnlessEditing
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CompletionCell")
        
        let rightView = UIButton.buttonWithType(.Custom) as! UIButton
        rightView.setImage(UIImage(named: "icoSearchLocate"), forState: .Normal)
        rightView.addTarget(self, action: "locateBtnPressed:", forControlEvents: .TouchUpInside)
        rightView.frame     = CGRectMake(0, 0, 50, 50)
        textField.rightView = rightView
        
        let tap = UITapGestureRecognizer(target: self, action: "endEditing")
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        mapView.alpha = 0
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.mapView.alpha = 1
        })
    }
    
    
    // MARK: - UI Actions
    
    
    @IBAction func cancelBtnPressed() {
        if self.delegate?.mapViewPickerControllerDidCancel?(self) == nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    @IBAction func actionBtnPressed(sender: UIButton) {
        if self.delegate?.mapViewPickerController?(self, didFinishPickerLocation: location) == nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func endEditing() {
        if textField.editing {
            view.endEditing(true)
            coordinateFromAddress(textField.text, completionHandler: { (location: CLLocation?, error: NSError?) -> Void in
                self.location = location
                if let loc = location {
                    self.centerMapViewToLocation(loc, spanLevel: 0.010)
                } else if let error = error {
                    self.text = NSLocalizedString("Invalid address", comment: "")
                }
            })
        }
    }
    
    
    func locateBtnPressed(sender: UIButton) {
        println("locate")
    }
    
    
    // MARK: - TextField delegate
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing()
        return false
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        openAutoCompletion()
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        closeAutoCompletion()
    }
    
    
    // MARK: - MapView delegate
    
    
    func mapView(mapView: MKMapView!, regionWillChangeAnimated animated: Bool) {
        closeAutoCompletion()
        raiseTextField()
        raisePin()
        textField.resignFirstResponder()
        text = ""
    }
    
    
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        lowerTextField()
        lowerPin()
        var location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        self.location = location
        addressFromCoordinate(location, completionHandler: { (address: String?, error: NSError?) -> Void in
            if let text = address {
                self.text = text
            } else if let error = error {
                self.text = NSLocalizedString("Invalid address", comment: "")
            }
        })
    }
    
    
    func mapViewDidFailLoadingMap(mapView: MKMapView!, withError error: NSError!) {
        println(error)
    }
    
    
    // MARK: - Gesture delegate
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let touchPoint = touch.locationInView(tableView)
        return tableView.hitTest(touchPoint, withEvent: nil) == nil
    }
    
    
    // MARK: - TableView delegate
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        text = cell?.textLabel?.text
        endEditing()
    }
    
    
    // MARK: - TableView datasource
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CompletionCell") as! UITableViewCell
        cell.selectionStyle  = .None
        cell.textLabel?.text = "dzadazazd \(indexPath.row)"
        
        return cell
    }
    
    
    // MARK: - Map animations
    
    
    func raiseTextField() {
        textFieldWrapperTopConstraint.constant = -80
        animateLayoutUpdate()
    }

    
    func raisePin() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.mapPin.transform = CGAffineTransformMakeTranslation(0, -10)
        }) { (completion:Bool) -> Void in
        }
    }
    
    
    func lowerTextField() {
        textFieldWrapperTopConstraint.constant = 25
        animateLayoutUpdate()
    }
    
    
    func lowerPin() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.mapPin.transform = CGAffineTransformIdentity
        }) { (completion:Bool) -> Void in
        }
    }
    
    
    func openAutoCompletion() {
        navBarHeightConstraint.constant    = -CGRectGetHeight(navBar.frame)
        tableViewHeightConstraint.constant = tableView.rowHeight * 2
        animateLayoutUpdate()
    }
    
    
    func closeAutoCompletion() {
        navBarHeightConstraint.constant    = -20
        tableViewHeightConstraint.constant = 0
        animateLayoutUpdate()
    }
    
    
    func animateLayoutUpdate() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    // MARK: - Address converting methods
    
    
    func coordinateFromAddress(address:String, completionHandler: ((CLLocation?, NSError?) -> Void)) {
        var geocoder:CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                completionHandler(placemark.location, error)
            } else {
                completionHandler(nil, error)
            }
        })
    }
    
    
    func addressFromCoordinate(location:CLLocation, completionHandler: ((String?, NSError?) -> Void)) {
        var geocoder:CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                completionHandler(ABCreateStringWithAddressDictionary(placemark.addressDictionary, true), nil)
            } else {
                completionHandler(nil, error)
            }
        })
    }
    
    
    // MARK: - Map methods
    
    
    func centerMapViewToLocation(location: CLLocation, spanLevel: CLLocationDegrees) {
        let span:MKCoordinateSpan     = MKCoordinateSpanMake(spanLevel, spanLevel)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location.coordinate, span)
        self.mapView.setRegion(region, animated: true)
    }

}
