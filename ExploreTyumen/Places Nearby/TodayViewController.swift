//
//  TodayViewController.swift
//  Places Nearby
//
//  Created by Глеб Завьялов on 12/12/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import NotificationCenter
import Firebase
import CoreLocation


let imageCache = NSCache<AnyObject, AnyObject>()


class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewMain: LoadingImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var typeView: UIView!
    
    var locationManager: CLLocationManager!
    var currentUserLoc: CLLocationCoordinate2D?
    
    
    var mainReference: DatabaseReference!
    
    
    var allPlaces:[PlaceModel] = []
    
    
    var placesNearby:[PlaceModel]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.fadeOut()
        imageViewMain.fadeOut()
        distanceLabel.fadeOut()
        typeView.fadeOut()
        
      
        
        FirebaseApp.configure()
        
        mainReference = Database.database().reference()

      
        getAllPlaces()
        
        
        self.updateViewConstraints()
        
        
    }
   
    
    func getAllPlaces(){
        var allPlaces:[PlaceModel] = []
        
        
        if(Connectivity.isConnectedToInternet){
            mainReference.child("places").observeSingleEvent(of: .value, with: {(snapshot) in
                for child in snapshot.children{
                    
                    
                    let data = child as? DataSnapshot
                    let value = data?.value as! NSDictionary
                    
                    let title:String = value["title"] as? String ?? ""
                    let discription:String = value["description"] as? String ?? ""
                    let adress: String = value["address"] as? String ?? ""
                    let latitude: Double = value["lat"] as? Double ?? 0
                    let longitude: Double = value["lon"] as? Double ?? 0
                    let uniqueId: Int = value["id"] as? Int ?? -1
                    
                    var typeplaceData: Int = value["type"] as? Int ?? 0
                    
                    var type: PlaceClassification = .historical
                    
                    switch(typeplaceData){
                    case 0:
                        type = .culture
                    case 1:
                        type = .historical
                    case 2:
                        type = .parks
                    case 3:
                        type = .havingFun
                    case 4:
                        type = .eatplaces
                    case 5:
                        type = .hotels
                    default:
                        type = .havingFun
                    }
                    
                    let imageUrl = value["mainImageUrl"] as? String ?? nil
                    
                    
                    
                    
                    let placeModel = PlaceModel(title: title, shortDescription: discription, imageMainUrl: imageUrl!, photos: [], location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), adress: adress, type: type, id: uniqueId)
                    allPlaces.append(placeModel)
                    
                }
                self.allPlaces = allPlaces
                
                self.locationManager = CLLocationManager()
                self.locationManager.delegate = self
                self.locationManager!.requestAlwaysAuthorization()
                self.locationManager!.pausesLocationUpdatesAutomatically = true
                self.locationManager!.allowsBackgroundLocationUpdates = false
                self.locationManager.activityType = CLActivityType.other
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                
                self.locationManager.startUpdatingLocation()
            }) { (error) in
                print(error)
            }
            
        }
        
        
    }
    
    
    
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        updateData()
        completionHandler(NCUpdateResult.newData)
    }
    
    
    
    
    
    
    
    
    
    
    
    func updateData(){
        
        titleLabel.text = placesNearby?[0].title ?? ""
        imageViewMain.loadImageWithCache(withUrl: placesNearby?[0].imageMainUrl ?? "")
        imageViewMain.layer.cornerRadius = 6
        imageViewMain.layer.masksToBounds = true
        
        let loc = CLLocation(latitude: placesNearby?[0].location?.latitude ?? 50.0, longitude: placesNearby?[0].location?.longitude ?? 50.0)
        
        
        let distance = loc.distance(from: CLLocation(latitude: currentUserLoc?.latitude ?? 50.0, longitude: currentUserLoc?.longitude ?? 50.0))
        
        let meters = Int(round(distance))
        
        
        
        if(meters >= 1000){
            let showingDis: Int = Int(round(Double(meters)/1000))
            
            distanceLabel.text = "> \(meters/1000) км"
            
        }else{
            distanceLabel.text = "\(meters) метров"
        }
        
        if(placesNearby?[0] != nil){
            locationManager.stopUpdatingLocation()
        }
        
        titleLabel.fadeIn()
        imageViewMain.fadeIn()
        distanceLabel.fadeIn()
        typeView.fadeIn()
        
        
        self.widgetPerformUpdate(completionHandler: {(smth) in
            print(smth)
            self.updateViewConstraints()
        })
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {return}
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        currentUserLoc = manager.location!.coordinate
        let userLoc = CLLocation(latitude: currentUserLoc?.latitude ?? 50.0, longitude:  currentUserLoc?.longitude ?? 50.0)
        
        let sortedPlaces = allPlaces.sorted(by: {userLoc.distance(from: CLLocation(latitude: $0.location!.latitude, longitude: $0.location!.longitude) ) < userLoc.distance(from: CLLocation(latitude:  $1.location!.latitude, longitude:  $1.location!.longitude)) })
        
        
        placesNearby = sortedPlaces
        print(placesNearby?[0].title)
        updateData()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(locations.last != nil){
            currentUserLoc = manager.location!.coordinate
            
            let userLoc = CLLocation(latitude: currentUserLoc?.latitude ?? 50.0, longitude:  currentUserLoc?.longitude ?? 50.0)
            
            let sortedPlaces = allPlaces.sorted(by: {userLoc.distance(from: CLLocation(latitude: $0.location!.latitude, longitude: $0.location!.longitude) ) < userLoc.distance(from: CLLocation(latitude:  $1.location!.latitude, longitude:  $1.location!.longitude)) })
            
            
            placesNearby = sortedPlaces
            print(placesNearby?[0].title)
            updateData()
        }
    }
    
}
