//
//  NearUserCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 13/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import CoreLocation

class NearUserCollectionViewCell: UICollectionViewCell, CLLocationManagerDelegate {
    @IBOutlet weak var imageView: LoadingImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var vcParent: ViewController?
    
    var previousPlace:PlaceModel?
    
    var locationManager: CLLocationManager!
    var currentUserLoc: CLLocationCoordinate2D?
    
    var placesNearby:[PlaceModel]?
    
    
    lazy var tyumen = TyumenApp()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.alpha = 0

    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let screenSize = UIScreen.main.bounds
        
        layoutAttributes.size.width = screenSize.width - 32
        
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    
    }
    
    
    
    func loadCell(_ vc: ViewController){
        titleLabel.text = ""
        distanceLabel.text = ""
        
        
        tyumen.fillPlaces(escaping: {(success) in
            self.vcParent = vc
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager!.requestAlwaysAuthorization()
            self.locationManager!.pausesLocationUpdatesAutomatically = true
            self.locationManager!.allowsBackgroundLocationUpdates = false
            self.locationManager.activityType = CLActivityType.other
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            
            
            let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.goToVC(gesture:)))
            
            self.backView.addGestureRecognizer(tapGestureRec)
        })
        
        
    }
    
    func startUpdatingLocation(){
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
    }
    
    
    @objc func goToVC(gesture: UIGestureRecognizer){
        let storyboard = UIStoryboard(name: "DetailedPlace", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailedPlaceViewController") as! DetailedPlaceViewController
        
        vc.placeFullModel = placesNearby?[0] ?? PlaceModel()
        
        vcParent?.present(vc, animated: true, completion: nil)
    }
    
    func updateData(){
        
        if(previousPlace?.title != placesNearby?[0].title){
            previousPlace = placesNearby?[0]
            titleLabel.text = placesNearby?[0].title ?? ""
            imageView.loadImageWithCache(withUrl: placesNearby?[0].imageMainUrl ?? "")
            imageView.layer.cornerRadius = 6
            imageView.layer.masksToBounds = true
            
            let loc = CLLocation(latitude: placesNearby?[0].location?.latitude ?? 50.0, longitude: placesNearby?[0].location?.longitude ?? 50.0)
            
            
            let distance = loc.distance(from: CLLocation(latitude: currentUserLoc?.latitude ?? 50.0, longitude: currentUserLoc?.longitude ?? 50.0))
            
            let meters = Int(round(distance))
            
            
            
            if(meters >= 1000){
                let showingDis: Int = Int(round(Double(meters)/1000))
                
                distanceLabel.text = "> \(meters/1000) км"
                
            }else{
                distanceLabel.text = "\(meters) метров"
            }
        }else{
            let loc = CLLocation(latitude: placesNearby?[0].location?.latitude ?? 50.0, longitude: placesNearby?[0].location?.longitude ?? 50.0)
            
            
            let distance = loc.distance(from: CLLocation(latitude: currentUserLoc?.latitude ?? 50.0, longitude: currentUserLoc?.longitude ?? 50.0))
            
            let meters = Int(round(distance))
            
            if(meters >= 1000){
                let showingDis: Int = Int(round(Double(meters)/1000))
                
                distanceLabel.text = "> \(meters/1000) км"
                
            }else{
                distanceLabel.text = "\(meters) метров"
            }
            
        }
        
        self.backView.fastFadeIn()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {return}
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentUserLoc = manager.location!.coordinate
        placesNearby = tyumen.getPlacesNearUser(currentUserLoc ?? CLLocationCoordinate2D())
        updateData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(locations.last != nil){
            DispatchQueue.main.async {
                self.currentUserLoc = manager.location!.coordinate
                self.placesNearby = self.tyumen.getPlacesNearUser(self.currentUserLoc ?? CLLocationCoordinate2D())
                
                self.updateData()
                
                
                
            }
        }
    }
}
