//
//  BestCategoriesCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 30/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class BestCategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageBackground: LoadingImageView!
    
    func setData(title: String, imageMainUrl: String, imageMain: UIImage, categorie: CategorieBestEnum){
        titleLabel.text = title
        
        switch categorie {
        case .places:
            categorieLabel.text = "Места"
            imageBackground.loadImageWithCache(withUrl: imageMainUrl)

        case .quests:
            categorieLabel.text = "Квесты"
            imageBackground.loadImageWithCache(withUrl: imageMainUrl)

        case .collections:
            categorieLabel.text = "Подборки"
        }
        
    }
    
}


enum CategorieBestEnum{
    case quests
    case places
    case collections
}
