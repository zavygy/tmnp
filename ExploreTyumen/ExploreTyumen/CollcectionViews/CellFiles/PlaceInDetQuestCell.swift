//
//  PlaceInDetQuestCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 3/6/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit

class PlaceInDetQuestCell: UICollectionViewCell {
    @IBOutlet weak var imageViewMain: LoadingImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func setData(_ model: PlaceModel){
        imageViewMain.loadImageWithCache(withUrl: model.imageMainUrl ?? "")
        titleLabel.text = model.title
        addressLabel.text = model.adress
    }
    
}
