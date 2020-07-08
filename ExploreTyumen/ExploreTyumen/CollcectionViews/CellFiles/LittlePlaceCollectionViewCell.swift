//
//  LittlePlaceCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 2/17/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit

class LittlePlaceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewMain: LoadingImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    func setData(_ model: PlaceModel){
        imageViewMain.layer.cornerRadius = 6
        imageViewMain.clipsToBounds = true
        
        imageViewMain.loadImageWithCache(withUrl: model.imageMainUrl ?? "")
        titleLabel.text = model.title
        
        addressLabel.text = model.adress ?? ""
        
        if(model.type != nil){
            switch(model.type!){
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
            classificationLabel.fadeOut()
        }
    }
}
