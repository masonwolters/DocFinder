//
//  ClinicMapViewController.swift
//  DocFinder
//
//  Created by Russell Ladd on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit
import MapKit

class ClinicMapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    var clinicsNearby: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadClinics()
    }
    
    func refreshMap() {
        if let clinicsNearby = clinicsNearby {
            for clinic in clinicsNearby {
                var annotation = MKPointAnnotation()
                var geoPoint = clinic.objectForKey("location") as PFGeoPoint
                annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude)
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func loadClinics() {
        println("load data")
        
        var query = PFQuery(className: "Clinic")
        
        query.findObjectsInBackgroundWithBlock() { (results: [AnyObject]!, error: NSError!) in
            self.clinicsNearby = results as? Array
            println("clinics nearby count: \(self.clinicsNearby!.count)")
            self.refreshMap()
        }
        
//        LocationHelper.sharedInstance.getCurrentLocation({ (location: CLLocation) -> Void in
//            
//            var geoPoint = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
////            query.whereKey("location", nearGeoPoint: geoPoint, withinKilometers: 100)
//            query.findObjectsInBackgroundWithBlock() { (results: [AnyObject]!, error: NSError!) in
//                self.clinicsNearby = results as? Array
//                println("clinics nearby count: \(self.clinicsNearby!.count)")
//                self.refreshMap()
//            }
//            
//        }, error: { (error: NSError) -> Void in
//            
//        })
    }
    
}
