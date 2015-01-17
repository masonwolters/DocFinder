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
    var successCallback: ((location: CLLocation) -> Void)?
    var errorCallback: ((error: NSError) -> Void)?
    
    func getCurrentLocation(success: (location: CLLocation) -> Void, error: (error: NSError) -> Void) {
        if (locationManager.location != nil) {
            success(location: locationManager.location)
        } else {
            successCallback  = success
            errorCallback = error
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let success = successCallback {
            success(location: locations.last as CLLocation)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        if let errorCallback = errorCallback {
            errorCallback(error: error)
        }
    }
    
    // MARK: Initialization
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
}
