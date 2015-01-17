//
//  LocationHelper.swift
//  DocFinder
//
//  Created by Mason Wolters on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

import UIKit

private let _LocationHelperSharedInstance = LocationHelper()

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    class var sharedInstance: LocationHelper {
        return _LocationHelperSharedInstance
    }
    
    let locationManager: CLLocationManager
    
    func getCurrentLocation(success: (location: CLLocation) -> Void, error: (error: NSError) -> Void) {
        
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
    }
    
    // MARK: Initialization
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
    }
    
}
