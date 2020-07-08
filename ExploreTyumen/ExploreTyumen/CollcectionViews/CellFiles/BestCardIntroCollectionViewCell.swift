//
//  BestCardIntroCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 2/16/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit

class BestCardIntroCollectionViewCell: UICollectionViewCell {
    
 
    
    @IBOutlet weak var imageView: LoadingImageView!
    
    var model:BestCardIntroModel?
    

    
    func setData(_ model: BestCardIntroModel){
        self.model = model
        
        imageView.loadImageWithCache(withUrl: model.imageMainUrl ?? "")
        
    }
}

