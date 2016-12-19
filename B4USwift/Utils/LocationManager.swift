//
//  LocationManager.swift
//  B4USwift
//
//  Created by admin on 12/7/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D?
    static let sharedManager = LocationManager()
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func askingPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func isCurrentLocation(location: CLLocationCoordinate2D) -> Bool {
        return (fabs(location.latitude - self.currentLocation!.latitude) < 0.001 &&
            fabs(location.longitude - self.currentLocation!.longitude) < 0.001);
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            currentLocation = locations[0].coordinate
            locationManager.stopUpdatingLocation()
        }
    }
}
