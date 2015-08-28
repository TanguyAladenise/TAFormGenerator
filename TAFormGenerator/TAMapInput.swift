//
//  TAMapInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 27/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit
import MapKit


class TAMapInput: UIView, TAInputProtocol, TAInputValidatorProtocol, MKMapViewDelegate, TAMapViewPickerControllerDelegate {

    private let mapView: MKMapView! = MKMapView(forAutoLayout: ())
    
    private weak var target: UIViewController?
    
    private var didSetupConstraints: Bool = false
    
    var selectedLocation: CLLocation?
    
    // MARK: - Lifecycle
    
    
    convenience init(coordinate: String?, target: UIViewController) {
        self.init(frame: CGRectZero)
        
        self.target = target
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        
        setup()
    }
    
    
    func setup() {
        addSubview(mapView)
        mapView.scrollEnabled = false
        mapView.zoomEnabled   = false
        mapView.rotateEnabled = false
        mapView.delegate      = self
        
        let tap = UITapGestureRecognizer(target: self, action: "tapHandler")
        mapView.addGestureRecognizer(tap)
    }
    
    
    // MARK: - Protocol
    
    
    func inputValue() -> AnyObject? {
        return selectedLocation
    }
    
    
    func validateInput(inputValidator: TAInputValidator) -> (Bool, NSError?) {
        var valid = inputValidator.validateMandatory(selectedLocation)
        var error = inputValidator.error

        return (valid, error)
    }
    
    
    // MARK: - UI actions
    
    
    func tapHandler() {
        let vc      = TAMapViewPickerController(nibName: "TAMapViewPickerController", bundle: nil)
        vc.delegate = self
        
        // Use target for presenting controller
        if let target = target {
            target.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Map picker delegate
    
    
    func mapViewPickerControllerDidCancel(picker: TAMapViewPickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func mapViewPickerController(picker: TAMapViewPickerController, didFinishPickerLocation location: CLLocation?) {
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            if let loc = location {
                self.selectedLocation = loc
                var annotation        = MKPointAnnotation()
                annotation.coordinate = loc.coordinate
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotation(annotation)
                
                let region = MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                self.mapView.setRegion(region, animated: true)
            }
        })
    }
    
    
    // MARK: - MapView delegate

    
    // MARK: - Layout
    
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            autoSetDimension(.Height, toSize: 140, relation: NSLayoutRelation.GreaterThanOrEqual)
            
            mapView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
}
