//
//  ThingsThatShouldBeDoneCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 11/26/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class ThingsThatShouldBeDoneCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var addTypeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addImageView: LoadingImageView!
    @IBOutlet weak var additionalView: UIView!
    
    var vcParent: TenThongsToDoViewController?
    
    var tModel:ThingModel?
    
    var tyumen = TyumenApp()
    
    func setData(_ model : ThingModel, vc: TenThongsToDoViewController){
        vcParent = vc
        tModel = model
        titleLabel.text = model.title
        descriptionLabel.text = model.text
        imageView.image = model.mainImage
        
        guard let typeAdd = model.sightsAdd else {
            return
        }
        
        
//        additionalView.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
//        additionalView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        additionalView.layer.shadowRadius = 10
//        additionalView.layer.shadowOpacity = 0.6
//        additionalView.layer.masksToBounds = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ThingsThatShouldBeDoneCollectionViewCell.showAdd(gesture:)))
        
        additionalView.addGestureRecognizer(tapGesture)
        
        
        switch typeAdd {
        case .places:
            addTypeLabel.text = "Место"
            tyumen.fillPlaces(escaping: {(success) in
                
                let pModel = self.tyumen.getFullPlace(byId: model.id ?? 0)
                
                    self.placeNameLabel.text = pModel?.title
                
                    self.addressLabel.text = pModel?.adress
                    self.addImageView.loadImageWithCache(withUrl: pModel?.imageMainUrl ?? "")
                
                
            })
        case .collections:
            addTypeLabel.text = "Подборка"
            tyumen.fillCollections(escaping: {(success) in
                
                let cModel = self.tyumen.getFullCollection(byId: model.id ?? 0)
                
                self.placeNameLabel.text = cModel?.title
                
                self.addressLabel.text = cModel?.shortDescription
                self.addImageView.loadImageWithCache(withUrl: cModel?.imageMainUrl ?? "")
                
                
                
            })
        case .quests:
            addTypeLabel.text = "Квест"
            
        tyumen.fillQuests(escaping: {(success) in
            let qModel = self.tyumen.getFullQuest(byId: model.id ?? 0)
            self.placeNameLabel.text = qModel?.title
            self.addImageView.loadImageWithCache(withUrl: qModel?.imageMainUrl ?? "")
        })
            
        }
        
    }
    
    
    @objc func showAdd(gesture: UIGestureRecognizer){
        
        switch tModel?.sightsAdd ?? .places {
        case .places:
            let storyboard = UIStoryboard(name: "DetailedPlace", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailedPlaceViewController") as! DetailedPlaceViewController
            
            vc.placeFullModel = tyumen.getFullPlace(byId: tModel?.id ?? 0)
            
            vcParent?.present(vc, animated: true, completion: nil)
            
        case .collections:
            let storyboard = UIStoryboard(name: "DetailedCollection", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailedCollectionViewController") as! DetailedCollectionViewController
            
            vc.collectionModel = tyumen.getFullCollection(byId: tModel?.id ?? 0)
            
            vcParent?.present(vc, animated: true, completion: nil)
            
            
        default:
            return
        }
    }
    
}


