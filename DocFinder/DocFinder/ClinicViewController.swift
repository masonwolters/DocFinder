//
//  ClinicViewController.swift
//  DocFinder
//
//  Created by Russell Ladd on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI

protocol ClinicViewControllerDelegate: class {
    
    func clinicViewControllerDidChangeClinicName(clinicViewController: ClinicViewController)
}

class ClinicViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Initialization
    
    init(clinic: PFObject) {
        
        self.clinic = clinic
        
        super.init(nibName: "ClinicViewController", bundle: nil)
        
        // Annotation
        
        updateAnnotationWithGeoPoint(clinic["location"] as PFGeoPoint)
        updateAnnotationWithName(clinic["name"] as String)
        
        // Navigation item
        
        navigationItem.title = "My Clinic"
        hidesBottomBarWhenPushed = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Delegate
    
    var delegate: ClinicViewControllerDelegate?
    
    // MARK: Model
    
    let geocoder = CLGeocoder()
    
    let clinic: PFObject
    
    let annotation = MKPointAnnotation()
    
    func updateAnnotationWithGeoPoint(geoPoint: PFGeoPoint) {
        annotation.coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
    
    func updateAnnotationWithName(name: String) {
        annotation.title = name
    }
    
    // MARK: Update location
    
    @IBAction func updateLocationBarButtonItemAction() {
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { geoPoint, error in
            
            if let geoPoint = geoPoint {
                
                self.clinic["location"] = geoPoint
                self.clinic.saveEventually()
                
                self.updateAnnotationWithGeoPoint(geoPoint)
                self.zoomMap(true)
                self.mapView.selectAnnotation(self.annotation, animated: true)
            }
        }
    }
    
    // MARK: View did load
    
    override func viewDidLoad() {
        
        mapView.addAnnotation(annotation)
        zoomMap(false)
        mapView.selectAnnotation(annotation, animated: false)
    }
    
    // MARK: Map view
    
    @IBOutlet var mapView: MKMapView!
    
    func zoomMap(animated: Bool) {
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 100 * 1000, 100 * 1000)
        mapView.setRegion(region, animated: animated)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if let reusedView = mapView.dequeueReusableAnnotationViewWithIdentifier("PinView") {
            
            return reusedView
            
        } else {
            
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PinView")
            
            view.canShowCallout = true
            view.draggable = true
            
            let renameButton = UIButton.buttonWithType(.InfoLight) as UIButton
            renameButton.addTarget(self, action: "renameButtonTouchUpInside", forControlEvents: .TouchUpInside)
            view.rightCalloutAccessoryView = renameButton
            
            return view
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if newState == .Ending {
            
            let geoPoint = PFGeoPoint(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            clinic["location"] = geoPoint
            clinic.saveEventually()
        }
    }
    
    // MARK: Rename button
    
    func renameButtonTouchUpInside() {
        
        let alertController = UIAlertController(title: "Rename Clinic", message: nil, preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Clinic Name"
            textField.text = self.clinic["name"] as String
            textField.autocapitalizationType = .Sentences
            textField.autocorrectionType = .Default
            textField.clearButtonMode = .Always
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
            
        })
        
        alertController.addAction(UIAlertAction(title: "Save", style: .Default) { action in
            
            let name = (alertController.textFields!.first as UITextField).text
            
            self.annotation.title = name
            self.clinic["name"] = name
            self.clinic.saveEventually()
            
            self.delegate?.clinicViewControllerDidChangeClinicName(self)
        })
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
