//
//  ThingModel.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 11/26/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit


class ThingModel{
    var title: String?
    var text: String?
    var mainImage: UIImage?
    var sightsAdd: SightClassification?
    var id: Int?
    
    init(title: String, text: String, image: UIImage, sightsAdd: SightClassification, id: Int) {
        self.title = title
        self.text = text
        self.mainImage = image
        self.id = id
        self.sightsAdd = sightsAdd
    }
    
    init(title: String, text: String, image: UIImage) {
        self.title = title
        self.text = text
        self.mainImage = image
    }
    

    
    
    init() {}
}


enum SightClassification{
    case places
    case quests
    case collections
}
