//
//  GroupPlaceModel.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 19/10/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class GroupPlaceModel {
    var title:String?
    var description: String?
    var mainImage: UIImage?
    var ids:[Int]?
    
    init(title: String, description: String, mImage: UIImage, placeIds: [Int]) {
        self.title = title
        self.description = description
        self.ids = placeIds
        self.mainImage = mImage
    }
    
}
