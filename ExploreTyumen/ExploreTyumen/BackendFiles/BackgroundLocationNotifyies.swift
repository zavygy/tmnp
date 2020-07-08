//
//  BackgroundLocationNotifyies.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 24/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications

class BLNotificationService {
    var locationManager: CLLocationManager!
    var currentUserLoc: CLLocationCoordinate2D?
    var placesNearby:[PlaceModel]?
    lazy var tyumen = TyumenApp()
    
    var lastPlace:PlaceModel?
    
    init() {
        locationManager = CLLocationManager()
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager!.requestAlwaysAuthorization()
        locationManager!.pausesLocationUpdatesAutomatically = false
        locationManager!.allowsBackgroundLocationUpdates = true
        
        
        locationManager.startUpdatingLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {return}
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentUserLoc = manager.location!.coordinate
        placesNearby = tyumen.getPlacesNearUser(currentUserLoc ?? CLLocationCoordinate2D())
        self.lastPlace = self.placesNearby?[0]
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            DispatchQueue.main.async {
                self.currentUserLoc = manager.location!.coordinate
                self.placesNearby = self.tyumen.getPlacesNearUser(self.currentUserLoc ?? CLLocationCoordinate2D())
                
                self.lastPlace = self.placesNearby?[0]
                
            }
        }
    }

    
}
