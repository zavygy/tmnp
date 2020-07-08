//
//  CollectionModel.swift
//  ExploreTyumen
//
//  Created by Глеб Завьялов on 11/16/18.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import Foundation

class CollectionModel {
    var title: String = ""
    var imageMainUrl: String = ""
    var shortDescription: String = ""
    var placesId:[Int] = []
    var uniqueId:Int = 0
    
    init(title: String, imageUrl: String ,shortDescription: String, places: [Int], id: Int) {
        self.title = title
        self.shortDescription = shortDescription
        self.placesId = places
        self.imageMainUrl = imageUrl
        self.uniqueId = id
    }
    
}
