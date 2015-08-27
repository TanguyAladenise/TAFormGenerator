//
//  TAMapInput.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 27/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit
import MapKit


class TAMapInput: UIView, TAInputProtocol, TAInputValidatorProtocol, MKMapViewDelegate {

    private let mapView: MKMapView! = MKMapView(forAutoLayout: ())
    
    private weak var target: UIViewController?
    
    private var didSetupConstraints: Bool = false
    
    
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
        return nil
    }
    
    
    func validateInput(inputValidator: TAInputValidator) -> (Bool, NSError?) {
        return (false, nil)
    }
    
    
    // MARK: - UI actions
    
    
    func tapHandler() {
        println("open map")
        let vc      = MapViewPickerController(nibName: "MapViewPickerController", bundle: nil)
        
        // Use target for presenting controller
        if let target = target {
            target.presentViewController(vc, animated: true, completion: nil)
        }
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
