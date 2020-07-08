//
//  PlacesViewController.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 18/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import CoreLocation

class TypeMassivePainfulCode{
    var placeClass: PlaceClassification!
    var bool: Bool
    init(_ placeClass: PlaceClassification, _ bool: Bool) {
        self.placeClass = placeClass
        self.bool = bool
    }
}

class PlacesViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var collectionViewTypes: UICollectionView!
    @IBOutlet weak var statusbarHeigthView: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewPlaces: UICollectionView!
//    @IBOutlet weak var heigthCollectionPlaces: NSLayoutConstraint!
    @IBOutlet weak var activityIndic: UIActivityIndicatorView!
    
    @IBOutlet weak var noCOnnectionLabel: UILabel!
    
    
    
    var segueMode:Bool = false
    
    lazy var tyumen = TyumenApp()
    
    var typeSortPlaces:[PlaceModel] = []
    
    var locationManager: CLLocationManager!
    var currentUserLoc: CLLocationCoordinate2D?
    
    var countPlaces = 0
    
    var stateMassive:[TypeMassivePainfulCode] = [TypeMassivePainfulCode(.culture, false), TypeMassivePainfulCode(.historical, false), TypeMassivePainfulCode(.parks, false), TypeMassivePainfulCode(.havingFun, false), TypeMassivePainfulCode(.eatplaces, false), TypeMassivePainfulCode(.hotels, false)]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewPlaces.fadeOut()
        noCOnnectionLabel.fadeOut()
        
        
        
        activityIndic.hidesWhenStopped = true
        activityIndic.style = .gray
        
        
        statusbarHeigthView.constant = UIApplication.shared.statusBarFrame.height
        
        collectionViewPlaces.delegate = self
        collectionViewPlaces.dataSource = self        
        
        collectionViewTypes.delegate = self
        collectionViewTypes.dataSource = self
        
        
        collectionViewPlaces.register(UINib.init(nibName: "PlaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlaceCollectionViewCell")
        collectionViewTypes.register(UINib.init(nibName: "TypePlaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TypePlaceCollectionViewCell")
        
        reload()

    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension PlacesViewController{
    func reload(){
        activityIndic.fadeIn()
        activityIndic.startAnimating()
        
        tyumen.fillPlaces(escaping: {(success) in
            if(success){
                self.collectionViewPlaces.reloadData()
                self.collectionViewPlaces.fadeIn()
                self.activityIndic.fadeOut()
            }else{
                self.collectionViewTypes.fadeOut()
                self.noCOnnectionLabel.fadeIn()
                self.activityIndic.fadeOut()
                
            }
        })
        
    }
    
   
    func setPlacesInCollectionView(completion: @escaping(Bool) -> Void){
        collectionViewPlaces.reloadData()

        completion(true)
    }
}


extension PlacesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == collectionViewPlaces){
            if(typeSortPlaces.count == 0){
                return tyumen.places.count
            }else{
                return typeSortPlaces.count
            }
        }else if(collectionView == collectionViewTypes){
            return stateMassive.count
        }else{
            return 0
        }
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionViewPlaces:
            if(typeSortPlaces.count == 0){
                let cell = collectionViewPlaces.dequeueReusableCell(withReuseIdentifier: "PlaceCollectionViewCell", for: indexPath) as! PlaceCollectionViewCell
                
                cell.setData(tyumen.places[indexPath.row], currentUserLoc)
                return cell
            }else{
                let cell = collectionViewPlaces.dequeueReusableCell(withReuseIdentifier: "PlaceCollectionViewCell", for: indexPath) as! PlaceCollectionViewCell
                
                cell.setData(typeSortPlaces[indexPath.row], currentUserLoc)
                return cell
            }
            
            
        case collectionViewTypes:
            let cell = collectionViewTypes.dequeueReusableCell(withReuseIdentifier: "TypePlaceCollectionViewCell", for: indexPath) as! TypePlaceCollectionViewCell
            
            cell.setData(stateMassive[indexPath.row].placeClass, stateMassive[indexPath.row].bool)
            
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collectionViewPlaces:
            let width = collectionView.layer.frame.width
            let heigth:CGFloat = 111
            return CGSize(width: width, height: heigth)
        case collectionViewTypes:
            return CGSize(width: 100, height: 36)
        default:
            return CGSize(width: 0, height: 0)
        }
        
    }
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == collectionViewTypes){
            stateMassive[indexPath.row].bool = !stateMassive[indexPath.row].bool
            
            collectionViewTypes.reloadData()
            collectionViewPlaces.fadeOut()
            
            var types: [PlaceClassification] = []
            
            
            
            for i in stateMassive{
                if(i.bool == true){
                    types.append(i.placeClass)
                }
            }
            
            
            typeSortPlaces = tyumen.getListCurrentType(of: types) ?? []
            
            
            
            
            
            
            
            collectionViewPlaces.reloadData()
            collectionViewPlaces.fadeIn()
            
            
        }else if(collectionView == collectionViewPlaces){
            segueMode = true
            if(typeSortPlaces.count != 0){
                let model = typeSortPlaces[indexPath.row]
                let storyboard = UIStoryboard(name: "DetailedPlace", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailedPlaceViewController") as! DetailedPlaceViewController
                
                vc.placeFullModel = model
                
                
                self.present(vc, animated: true, completion: nil)
            }else{
                let model = tyumen.places[indexPath.row]
                
                let storyboard = UIStoryboard(name: "DetailedPlace", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailedPlaceViewController") as! DetailedPlaceViewController
                
                vc.placeFullModel = model
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(collectionView == collectionViewTypes){
            stateMassive[indexPath.row].bool = !stateMassive[indexPath.row].bool
            
            collectionViewTypes.reloadData()
            collectionViewPlaces.reloadData()
        }
    }
    
    
}



