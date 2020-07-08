//
//  TypePlaceCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 19/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class TypePlaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewBackground: UIView!
    
    func setData(_ type: PlaceClassification, _ state: Bool){
        
        switch type {
            case .culture:
                typeLabel.text = "Культура"
                viewBackground.backgroundColor = UIColor(rgbColorCodeRed: 214, green: 111, blue: 92, alpha: 100)
        case .historical:
            typeLabel.text = "История"
            viewBackground.backgroundColor = UIColor(rgbColorCodeRed: 224, green: 170, blue: 103, alpha: 100)
        case .parks:
            typeLabel.text = "Парки"
            viewBackground.backgroundColor = UIColor(rgbColorCodeRed: 117, green: 201, blue: 114, alpha: 100)
        case .havingFun:
            typeLabel.text = "Отдых"
            viewBackground.backgroundColor = UIColor(rgbColorCodeRed: 110, green: 197, blue: 206, alpha: 100)
        case .eatplaces:
            typeLabel.text = "Еда"
            viewBackground.backgroundColor = UIColor(rgbColorCodeRed: 172, green: 128, blue: 212, alpha: 100)
        case .hotels:
            typeLabel.text = "Отели"
            viewBackground.backgroundColor = UIColor(rgbColorCodeRed: 110, green: 158, blue: 214, alpha: 100)
            
        }
        
        switch state {
        case true:
            viewState.backgroundColor = viewBackground.backgroundColor
            typeLabel.textColor = UIColor.white
        case false:
            viewState.backgroundColor = UIColor.white
            typeLabel.textColor = UIColor(rgbColorCodeRed: 74, green: 74, blue: 74, alpha: 100)
        
        }
         
    }
}
