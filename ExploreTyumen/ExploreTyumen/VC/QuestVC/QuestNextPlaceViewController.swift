//
//  NextPlaceViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 22/09/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import MapKit
import Contacts
import MapKitGoogleStyler

class QuestNextPlaceViewController: UIViewController {

    @IBOutlet weak var iconPlaceView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var mapViewContain: UIView!
    @IBOutlet weak var onPointButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var openInMap: UIButton!
    
    
    var backModel:BackgroundLayerQuestModel?
    var questModel: QuestModel?
    
    lazy var tyumen = TyumenApp()

    var initloc:CLLocation?
    
    let regionRadius: CLLocationDistance = 700


    var placeFullModel:PlaceModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        iconPlaceView.asCircle()
        iconPlaceView.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        iconPlaceView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        iconPlaceView.layer.shadowRadius = 8
        iconPlaceView.layer.shadowOpacity = 0.5
        iconPlaceView.layer.masksToBounds = false
        
        
        mapViewContain.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        mapViewContain.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        mapViewContain.layer.shadowRadius = 8
        mapViewContain.layer.shadowOpacity = 0.5
        
        
        onPointButton.layer.cornerRadius = 20
        
        
        
        tyumen.fillPlaces(escaping: {(success) in
            if(success){
                let placeModel =  self.tyumen.getFullPlace(byId: self.questModel?.placesForQuests?[self.backModel?.placePositionInQuest ?? 0] ?? 0)
                
                self.titleLabel.text = placeModel?.title
                self.addressLabel.text = placeModel?.adress
                
                
                let placePoint = PlacePoint(title: placeModel!.title!, locationName: placeModel!.title!, coordinate: placeModel?.location ?? CLLocationCoordinate2D())
                
                self.placeFullModel = placeModel
                
                self.mapView.delegate = self
                
                
                self.mapView.addAnnotation(placePoint)
                
                self.configureTileOverlay()
                
                self.mapView.showsCompass = false
                self.mapView.showsScale = false
            
                
                self.mapView.showsUserLocation = true
                
                
                self.openInMap.backgroundColor = .clear
                self.openInMap.layer.cornerRadius = 5
                self.openInMap.layer.borderWidth = 1
                self.openInMap.layer.borderColor = UIColor.white.cgColor
                
                
                self.initloc = CLLocation(latitude: placeModel!.location!.latitude, longitude: placeModel!.location!.longitude)
                
                
                self.centerMapOnLocation(location: self.initloc ?? CLLocation())
                
            }
        })

    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func configureTileOverlay() {
        // We first need to have the path of the overlay configuration JSON
        guard let overlayFileURLString = Bundle.main.path(forResource: "mapStyleRetro", ofType: "json") else {
            return
        }
        let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
        
        // After that, you can create the tile overlay using MapKitGoogleStyler
        guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
            return
        }
        
        // And finally add it to your MKMapView
        mapView.addOverlay(tileOverlay)
    }

    @IBAction func onPointAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QPlaceDescriptionViewController") as! QPlaceDescriptionViewController
        
        vc.backModel = backModel
        vc.questModel = questModel
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func openInMapAction(_ sender: Any) {
        let coordintes = CLLocationCoordinate2DMake(placeFullModel!.location!.latitude, placeFullModel!.location!.longitude)
        
        let regionSpan =  MKCoordinateRegion(center: coordintes, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        let placemark = MKPlacemark(coordinate: coordintes, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeFullModel!.title!
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center)
            ] as [String : Any])
    }
    
    
}


extension QuestNextPlaceViewController: MKMapViewDelegate{}

