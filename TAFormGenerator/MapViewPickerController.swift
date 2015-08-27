//
//  MapViewPickerController.swift
//  TAFormGenerator
//
//  Created by Tanguy Aladenise on 27/08/2015.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit
import MapKit

class MapViewPickerController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var textFieldWrapper: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapPin: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        
    }
    
    
    
    // MARK: - MapView delegate
    
    
    func mapView(mapView: MKMapView!, regionWillChangeAnimated animated: Bool) {
        raisePin()
    }
    
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        lowerPin()
        var location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
//        addressFromCoordinate(location)
    }
    
    
    // MARK: - Map animations
    
    
    func raisePin() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.mapPin.transform = CGAffineTransformMakeTranslation(0, -10)
            }) { (completion:Bool) -> Void in
        }
    }
    
    
    func lowerPin() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.mapPin.transform = CGAffineTransformIdentity
        }) { (completion:Bool) -> Void in
                
        }
    }

}
