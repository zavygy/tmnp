//
//  CollectionPlaceCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 23/01/2019.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit

class CollectionPlaceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewMain: LoadingImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var isOpenLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var titleLabelConstraint: NSLayoutConstraint!
    
    
    
    func setData(_ placeModel: PlaceModel){
        
        imageViewMain.loadImageWithCache(withUrl: placeModel.imageMainUrl ?? "")
        titleLabel.text = placeModel.title
        
        
        if(placeModel.allDay == true){
            isOpenLabel.text = "Открыто круглосуточно"
        }else{
            switch(Date().dayOfWeek()!){
            case "Понедельник":
                isOpenLabel.text = "Сегодня: \(placeModel.timeTable!.mondayTime!)"
            case "Вторник":
                isOpenLabel.text = "Сегодня: \(placeModel.timeTable!.tuesdayTime!)"
                
            case "Среда":
                isOpenLabel.text = "Сегодня: \(placeModel.timeTable!.wednesdayTime!)"
                
            case "Четверг":
                isOpenLabel.text = "Сегодня: \(placeModel.timeTable!.thursdayTime!)"
            case "Пятница":
                isOpenLabel.text = "Сегодня: \(placeModel.timeTable!.fridayTime!)"
            case "Суббота":
                isOpenLabel.text = "Сегодня: \(placeModel.timeTable!.saturdayTime!)"
            case "Воскресенье":
                isOpenLabel.text = "Сегодня: \(placeModel.timeTable!.sundayTime!)"
            default:
                isOpenLabel.text = "Сегодня неработает"
            }
        }
        
        
        if(placeModel.type != nil){
            let type = placeModel.type!
            
            switch(type){
            case .culture:
                typeLabel.text = "Культура"
                typeLabel.textColor = UIColor(rgbColorCodeRed: 214, green: 111, blue: 92, alpha: 100)
            case .historical:
                typeLabel.text = "История"
                typeLabel.textColor = UIColor(rgbColorCodeRed: 224, green: 170, blue: 103, alpha: 100)
            case .parks:
                typeLabel.text = "Парки"
                typeLabel.textColor = UIColor(rgbColorCodeRed: 117, green: 201, blue: 114, alpha: 100)
            case .havingFun:
                typeLabel.text = "Отдых"
                typeLabel.textColor = UIColor(rgbColorCodeRed: 110, green: 197, blue: 206, alpha: 100)
            case .eatplaces:
                typeLabel.text = "Еда"
                typeLabel.textColor = UIColor(rgbColorCodeRed: 172, green: 128, blue: 212, alpha: 100)
            case .hotels:
                typeLabel.text = "Отели"
                typeLabel.textColor = UIColor(rgbColorCodeRed: 110, green: 158, blue: 214, alpha: 100)
            }
            
            if(placeModel.subtitle != nil){
                descriptionLabel.text = placeModel.subtitle
            }
            
        }
        
        
  
        
    }
    
    
    func heightForLable(labelWidth: CGFloat, numberOfLines: Int = 1, labelText: String, labelFont: UIFont) -> CGFloat {
        let tempLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
        tempLabel.numberOfLines = numberOfLines
        tempLabel.text = labelText
        tempLabel.font = labelFont
        tempLabel.sizeToFit()
        return tempLabel.frame.height
    }
    
}
