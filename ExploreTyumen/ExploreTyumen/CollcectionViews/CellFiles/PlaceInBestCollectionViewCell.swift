//
//  PlaceInBestCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 2/22/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit

class PlaceInBestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewMain: LoadingImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    func setData(_ model: PlaceModel){
        imageViewMain.loadImageWithCache(withUrl: model.imageMainUrl ?? "")
        titleLabel.text = model.title
        descriptionLabel.text = model.subtitle
        
    }
    
}
