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
        
        self.loadData()
    }
    
    func refreshMap() {
        
    }
    
    func loadData() {
        
        var query = PFQuery(className: "Clinic")
        
        LocationHelper.sharedInstance.getCurrentLocation({ (location: CLLocation) -> Void in
            
            var geoPoint = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            query.whereKey("location", nearGeoPoint: geoPoint, withinKilometers: 100)
            query.findObjectsInBackgroundWithBlock() { (results: [AnyObject]!, error: NSError!) in
                self.clinicsNearby = results as? Array
                self.refreshMap()
            }
            
        }, error: { (error: NSError) -> Void in
            
        })
    }
    
}
