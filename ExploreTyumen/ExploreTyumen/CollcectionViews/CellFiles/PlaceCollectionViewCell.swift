//
//  PlaceCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 18/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import CoreLocation


class PlaceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: LoadingImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var moreAction: UIButton!
    
    @IBOutlet weak var classificationView: UIView!
    @IBOutlet weak var classificationLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    var globalModel:PlaceModel?
 
    
    
    func setData(_ placeModel: PlaceModel, _ forDistance: CLLocationCoordinate2D?) {
        globalModel = placeModel
        
        imageView.image = UIImage()
        
        imageView.loadImageWithCache(withUrl: placeModel.imageMainUrl!)
        
        titleLabel.text = placeModel.title
        distanceLabel.text = placeModel.adress
        
        
        if(placeModel.type != nil){
            switch(placeModel.type!){
            case .culture:
                classificationLabel.text = "Культура"
                classificationLabel.textColor = UIColor(rgbColorCodeRed: 214, green: 111, blue: 92, alpha: 100)
            case .historical:
                classificationLabel.text = "История"
                classificationLabel.textColor = UIColor(rgbColorCodeRed: 224, green: 170, blue: 103, alpha: 100)
            case .parks:
                classificationLabel.text = "Парки"
                classificationLabel.textColor = UIColor(rgbColorCodeRed: 117, green: 201, blue: 114, alpha: 100)
            case .havingFun:
                classificationLabel.text = "Отдых"
                classificationLabel.textColor = UIColor(rgbColorCodeRed: 110, green: 197, blue: 206, alpha: 100)
            case .eatplaces:
                classificationLabel.text = "Еда"
                classificationLabel.textColor = UIColor(rgbColorCodeRed: 172, green: 128, blue: 212, alpha: 100)
            case .hotels:
                classificationLabel.text = "Отели"
                classificationLabel.textColor = UIColor(rgbColorCodeRed: 110, green: 158, blue: 214, alpha: 100)
            }
        }else{
            self.classificationView.fadeOut()
        }
    }
}
