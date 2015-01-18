//
//  IssueDetailsViewController.swift
//  DocFinder
//
//  Created by Russell Ladd on 1/18/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit
import MapKit

class IssueDetailsViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Initialization
    
    init(issue: PFObject) {
        
        self.issue = issue
        
        super.init(nibName: "IssueDetailsViewController", bundle: nil)
        
        // Annotation
        
        updateAnnotationWithGeoPoint(issue["location"] as PFGeoPoint)
        updateAnnotationWithName(issue["locationName"] as String)
        
        // Navigation item
        
        navigationItem.title = "Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Directions", style: .Plain, target: self, action: "directionsBarButtonItemAction")
        hidesBottomBarWhenPushed = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Model
    
    let issue: PFObject
    
    let annotation = MKPointAnnotation()
    
    func updateAnnotationWithGeoPoint(geoPoint: PFGeoPoint) {
        annotation.coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
    
    func updateAnnotationWithName(name: String) {
        annotation.title = name
    }
    
    // MARK: View did load
    
    let locationHelper = LocationHelper()
    
    override func viewDidLoad() {
        
        mapView.addAnnotation(annotation)
        zoomMap(false)
        mapView.selectAnnotation(annotation, animated: false)
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { geoPoint, error in
            
            if let geoPoint = geoPoint {
                
                let distance = geoPoint.distanceInKilometersTo(self.issue["location"] as PFGeoPoint)
                let roundedDistance = distance.format(".1")
                
                self.annotation.subtitle = "\(roundedDistance) km"
            }
        }
    }
    
    // MARK: Map view
    
    @IBOutlet var mapView: MKMapView!
    
    func zoomMap(animated: Bool) {
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 100 * 1000, 100 * 1000)
        mapView.setRegion(region, animated: animated)
    }
    
    // MARK: Directions
    
    func directionsBarButtonItemAction() {
        
        let geocoder = CLGeocoder()
        
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            if let placemark = placemarks?.first as? CLPlacemark {
                
                let toMapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
                
                MKMapItem.openMapsWithItems([toMapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey: ""])
            }
        }
    }
}

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}
