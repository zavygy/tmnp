//
//  PhotoCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 1/13/19.
//  Copyright © 2019 Глеб Завьялов. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: LoadingImageView!
 
    func setData(_ url: String){
        
       
        imageView.loadImageWithCache(withUrl: url)
        
    }
}
