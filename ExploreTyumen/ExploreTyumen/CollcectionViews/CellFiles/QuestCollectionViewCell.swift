//
//  QuestCollectionViewCell.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 28/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class QuestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: LoadingImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var littleIntroLabel: UILabel!
    @IBOutlet weak var derzhuVKurseView: UIView!
    
    
    lazy var tyumen = TyumenApp()
    
    var globalModel: QuestModel?
    
    func setData(_ model: QuestModel){
        
        globalModel = model
        
        imageView.loadImageWithCache(withUrl: model.imageMainUrl ?? "")
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
     
        
        littleIntroLabel.text = "С семьёй"
        
        derzhuVKurseView.layer.shadowColor = UIColor(rgbColorCodeRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        derzhuVKurseView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        derzhuVKurseView.layer.shadowRadius = 5
        derzhuVKurseView.layer.shadowOpacity = 0.3
        derzhuVKurseView.layer.masksToBounds = false
        
        
        
    }
    
 
}
