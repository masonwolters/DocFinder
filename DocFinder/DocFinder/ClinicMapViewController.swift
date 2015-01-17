//
//  ClinicMapViewController.swift
//  DocFinder
//
//  Created by Russell Ladd on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit
import MapKit

class ClinicMapViewController: UIViewController, MKMapViewDelegate {
    
    var clinicsNearby: [PFObject]?
    
    //MARK: Model
    
    func loadClinicsInRegion(region: MKCoordinateRegion) {
        var query = PFQuery(className: "Clinic")
        
        var radius = region.span.latitudeDelta * 110.54
        if region.span.longitudeDelta * 111.320 * cos(region.center.latitude) > radius {
            radius = region.span.longitudeDelta * 111.320 * cos(region.center.latitude)
        }
        
        var geoPoint = PFGeoPoint(latitude: region.center.latitude, longitude: region.center.longitude)
        query.whereKey("location", nearGeoPoint: geoPoint, withinKilometers: radius)
        query.findObjectsInBackgroundWithBlock() { (results: [AnyObject]!, error: NSError!) in
            self.clinicsNearby = results as? Array
            self.refreshMap()
        }
    }
    
    //MARK: View
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationHelper.sharedInstance.getCurrentLocation({ (location: CLLocation) -> Void in
            self.zoomMap(location, radius: 200)
        }, error: { (error: NSError) -> Void in
                
        })
    }
    
    func refreshMap() {
        mapView.removeAnnotations(mapView.annotations)
        
        if let clinicsNearby = clinicsNearby {
            for clinic in clinicsNearby {
                var annotation = MKPointAnnotation()
                var geoPoint = clinic.objectForKey("location") as PFGeoPoint
                annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude)
                annotation.title = clinic.objectForKey("name") as String
                
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func zoomMap(center: CLLocation, radius: Double) {
        var region = MKCoordinateRegionMakeWithDistance(center.coordinate, radius * 1000, radius * 1000)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        println("region did change animated: \(animated)")
        self.loadClinicsInRegion(mapView.region)
    }
    
}
