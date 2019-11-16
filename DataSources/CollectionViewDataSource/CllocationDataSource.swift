//
//  CllocationDataSource.swift
//  Laundry
//
//  Created by OSX on 30/05/18.
//  Copyright © 2018 OSX. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

typealias DidUpdatecurrentLocation = (_ locationManager:CLLocationManager,_ place: [CLLocation]?) -> ()

class CLlocationDataSource:NSObject {
    
    //Properties
    static let shared = CLlocationDataSource()
    
    private let locationManager = CLLocationManager()
    private var didUpdateCurrentLocation:DidUpdatecurrentLocation?
}

//Cllocation delegate function
extension CLlocationDataSource:CLLocationManagerDelegate {
    
    func getCurrentLocation(didUpdateCurrentLocation:DidUpdatecurrentLocation?) { //set location manager properties
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation() //updating location start
        self.didUpdateCurrentLocation = didUpdateCurrentLocation
    }
    
    func stopUpdatingLocation() {
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if let block = didUpdateCurrentLocation{
            block(manager, locations)
        }
    }
}
